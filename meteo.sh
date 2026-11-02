#!/usr/bin/env bash

# Load shared functions
source "$(dirname "$0")/lib.sh"

# Display usage information
usage() {
    printf 'Usage: ./meteo.sh [CITY]\n'
    printf 'Example: ./meteo.sh Bamenda\n'
}

# Check the number of arguments
[[ $# -le 1 ]] || {
    usage
    exit 2
}

# Select city from argument, environment variable or default
city="${1:-${METEO_CITY:-Yaounde}}"

# Validate city
[[ -n "$city" ]] || die "City name cannot be empty" 2

# Replace spaces with +
city_url="${city// /+}"

# Build weather API URL
url="https://wttr.in/${city_url}?format=j1"

# Fetch weather information
response=$(fetch_url "$url") || exit $?

# Extract current temperature
temperature=$(jq -r \
    '.current_condition[0].temp_C // empty' <<< "$response")

# Extract weather description
description=$(jq -r \
    '.current_condition[0].weatherDesc[0].value // empty' <<< "$response")

# Extract humidity
humidity=$(jq -r \
    '.current_condition[0].humidity // empty' <<< "$response")

# Validate weather information
[[ "$temperature" =~ ^-?[0-9]+([.][0-9]+)?$ ]] ||
    die "Unable to retrieve temperature for $city" 1

[[ -n "$description" ]] ||
    die "Unable to retrieve weather description for $city" 1

[[ "$humidity" =~ ^[0-9]+$ ]] ||
    die "Unable to retrieve humidity for $city" 1

# Display weather information
printf "%s: %s°C, %s, humidity %s%%\n" \
    "$city" "$temperature" "$description" "$humidity"
