#!/usr/bin/env bash

### Config
input_file="$1"
scroll_width="$2"
delay=0.3

if [[ ! -f "$input_file" || -z "$scroll_width" || "$scroll_width" -le 0 ]]; then
    printf "Usage: %s <input_file> <scroll_width>\n" "$0"
    exit 1
fi

# Initialize
i=0
last_checksum=""

while true; do
    # Read lines with mapfile
    mapfile -t lines < "$input_file"
    prefix="${lines[0]}"
    scroll_text="${lines[1]}"

    # Remove Windows carriage returns
    prefix="${prefix//$'\r'/}"
    prefix="${prefix//$'\n'/}"

    scroll_text="${scroll_text//$'\r'/}"
    scroll_text="${scroll_text//$'\n'/}"

    # Ensure both lines exist
    prefix="${prefix:-}"
    scroll_text="${scroll_text:-}"

    # Generate checksum of both lines
    current_checksum=$(printf "%s\n%s" "$prefix" "$scroll_text" | md5sum | awk '{print $1}')

    # If content changed, reset buffer
    if [[ "$current_checksum" != "$last_checksum" ]]; then
        last_checksum="$current_checksum"

        # Pad the scroll text with 3 spaces for smooth loop
        scroll_buffer="${scroll_text}   ${scroll_text}   "
        scroll_len=$(printf "%s" "$scroll_buffer" | wc -m)
        i=0
    fi

    # Scroll segment (UTF-8 safe with cut -c)
    start=$(( i % scroll_len ))
    segment=$(printf "%s" "$scroll_buffer" | cut -c $((start + 1))-$((start + scroll_width)))

    # Replace regular spaces with non-breaking spaces
    nbsp=$'\u00A0'
    segment="${segment// /$nbsp}"

    # Output with fixed width (avoids jitter)
    printf "%s%-*.*s\n" "$prefix" "$scroll_width" "$scroll_width" "$segment"

    sleep "$delay"
    ((i++))
done
