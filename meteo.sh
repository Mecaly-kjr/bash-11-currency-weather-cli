#!/usr/bin/env bash

# Load shared functions
source "$(dirname "$0")/lib.sh"

# Display usage information
usage() {
    printf 'Usage: ./meteo.sh [CITY]\n'
    printf 'Example: ./meteo.sh Bamenda\n'
}

# Check the number of arguments
if [[ $# -gt 1 ]]; then
    usage
    exit 2
fi

# Select city from argument, environment variable or default
city="${1:-${METEO_CITY:-Yaounde}}"

# Validate city
[[ -n "$city" ]] || die "City name cannot be empty" 2

# URL-encode the city name
city_url=$(jq -rn --arg c "$city" '$c | @uri')

# Build weather API URL
url="https://wttr.in/${city_url}?format=j1"

# Fetch weather information and HTTP status
raw_response=$(fetch_url_with_status "$url") || exit $?

# Separate response body and HTTP status
http_status="${raw_response##*$'\n'}"
response="${raw_response%$'\n'*}"

# Handle HTTP errors
if [[ "$http_status" != "200" ]]; then
    if [[ "$response" =~ [Nn]ot[[:space:]]found|[Uu]nknown[[:space:]]location|[Ll]ocation[[:space:]]not[[:space:]]found ]]; then
        die "City '$city' not found. Please check the city name." 2
    fi

    die "Weather service returned HTTP $http_status. Please try again later." 1
fi

# Check whether the response is valid JSON
if ! jq -e . >/dev/null 2>&1 <<< "$response"; then
    die "Invalid weather data received for $city" 1
fi

# Extract current weather information
temperature=$(jq -r \
    '.current_condition[0].temp_C // empty' <<< "$response")

description=$(jq -r \
    '.current_condition[0].weatherDesc[0].value // empty' <<< "$response")

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
printf '%s: %s°C, %s, humidity %s%%\n' \
    "$city" "$temperature" "$description" "$humidity"