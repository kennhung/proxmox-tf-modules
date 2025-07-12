#!/bin/bash

set -e

read_json() {
    jq -r '.url'
}

read_json_output=$(jq -r '.url' <&0)
URL=$(echo "$read_json_output" | sed -n '1p')

SERIAL=$(curl -sL "$URL" | grep "^serial=" | cut -d'=' -f2)

jq -n --arg serial "$SERIAL" '{"serial": $serial}'
