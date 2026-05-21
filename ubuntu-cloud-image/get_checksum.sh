#!/bin/bash

set -e

read_json() {
    jq -r '.url, .image'
}

read_json_output=$(jq -r '.url, .image' <&0)
URL=$(echo "$read_json_output" | sed -n '1p')
IMAGE=$(echo "$read_json_output" | sed -n '2p')

CHECKSUM=$(curl -s "$URL" | grep "$IMAGE" | awk '{print $1}')

jq -n --arg checksum "$CHECKSUM" '{"checksum": $checksum}'
