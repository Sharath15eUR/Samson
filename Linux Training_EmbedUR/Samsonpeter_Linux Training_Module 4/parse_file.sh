#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE="output.txt"

> "$OUTPUT_FILE"

while IFS= read -r line; do
    FRAME_TIME=$(echo "$line" | grep -oP '"frame.time"\s*:\s*"\K[^"]+')
    WLAN_TYPE=$(echo "$line" | grep -oP  '"wlan.fc.type"\s*:\s*"\K[^"]+')
    WLAN_SUBTYP=$(echo "$line" | grep -oP '"wlan.fc.subtype"\s*:\s*"\K[^"]+')

    if [[ -n "$FRAME_TIME" || -n "$WLAN_TYPE" || -n "$WLAN_SUBTYP" ]]; then
        {
            [[ -n "$FRAME_TIME" ]] && echo "\"frame.time\": \"$FRAME_TIME\"" 
            [[ -n "$WLAN_TYPE" ]] && echo "\"wlan.fc.type\": \"$WLAN_TYPE\""
            [[ -n "$WLAN_SUBTYP" ]] && echo "\"wlan.fc.subtype\":\"$WLAN_SUBTYP\""
        } >> "$OUTPUT_FILE"
    fi
done < "$INPUT_FILE"
echo "Data saved in '$OUTPUTFILE'."
