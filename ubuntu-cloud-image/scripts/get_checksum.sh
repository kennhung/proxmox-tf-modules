#!/bin/bash

set -e

read_json() {
    jq -r '.url, .filename'
}

read_json_output=$(jq -r '.url, .filename' <&0)
URL=$(echo "$read_json_output" | sed -n '1p')
FILENAME=$(echo "$read_json_output" | sed -n '2p')

CHECKSUM=$(curl -sL "$URL" | grep "$FILENAME" | awk '{print $1}')

jq -n --arg checksum "$CHECKSUM" '{"checksum": $checksum}'
