#!/usr/bin/env bash

# Load shared functions
source "$(dirname "$0")/lib.sh"

# Display usage information
usage() {
    printf 'Usage: ./fx.sh AMOUNT FROM TO\n'
    printf 'Example: ./fx.sh 250 USD XAF\n'
}

# Check the number of arguments
if [[ $# -ne 3 ]]; then
    usage
    exit 2
fi

# Read arguments
amount="$1"
from="${2^^}"
to="${3^^}"

# Validate amount format
[[ "$amount" =~ ^[0-9]+([.][0-9]+)?$ ]] ||
    die "Amount must be a number, like 250 or 12.5" 2

# Validate that amount is positive
awk -v amount="$amount" 'BEGIN { exit !(amount > 0) }' ||
    die "Amount must be greater than zero" 2

# Validate currency codes
[[ "$from" =~ ^[A-Z]{3}$ ]] ||
    die "Source currency must contain exactly 3 letters" 2

[[ "$to" =~ ^[A-Z]{3}$ ]] ||
    die "Target currency must contain exactly 3 letters" 2

# Fetch live exchange rates
url="https://open.er-api.com/v6/latest/$from"
response=$(fetch_url "$url") || exit $?

# Check API response
result=$(jq -r '.result // empty' <<< "$response")

if [[ "$result" != "success" ]]; then
    error_type=$(jq -r '.["error-type"] // empty' <<< "$response")

    if [[ "$error_type" == "unsupported-code" ]]; then
        die "Unknown currency: $from" 2
    fi

    die "Currency API request was unsuccessful" 1
fi

# Get the target currency rate
rate=$(jq -r --arg currency "$to" \
    '.rates[$currency] // empty' <<< "$response")

# Check whether target currency exists
[[ "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]] ||
    die "Unknown currency: $to" 2

# Calculate converted amount
converted=$(awk -v amount="$amount" -v rate="$rate" \
    'BEGIN { printf "%.2f", amount * rate }')

# Display conversion result
printf "%s %s = %s %s (rate %s)\n" \
    "$amount" "$from" "$converted" "$to" "$rate"
