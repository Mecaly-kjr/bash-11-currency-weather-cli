#!/usr/bin/env bash

# Display an error message and exit
die() {
    local message="$1"
    local exit_code="${2:-1}"

    printf 'Error: %s\n' "$message" >&2
    exit "$exit_code"
}

# Fetch data from an API
fetch_url() {
    local url="$1"
    local response

    response=$(curl -fsS --max-time 10 "$url") ||
        die "Network error: unable to connect. Check your internet connection." 1

    printf '%s\n' "$response"
}
