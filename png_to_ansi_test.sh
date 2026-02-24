#!/usr/bin/env bash
# png2ansi_final_corrected.sh
# Converts a PNG to ANSI using half-blocks and horizontal RLE
# Optional file output

convert_from_hex() {
    local hex=$1
    hex="${hex:-#000000}"       # default black if empty
    hex="${hex/#\#/}"            # remove leading #
    hex="${hex:0:6}"             # drop alpha if present
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf '%d;%d;%d' "$r" "$g" "$b"
}

if [[ -z $1 ]]; then
    printf 'Syntax error: Missing <filename>\n'
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

[[ -n "$OUTPUT" ]] && exec > "$OUTPUT"

width=$(identify -format "%w" "$INPUT")
height=$(identify -format "%h" "$INPUT")

# -----------------------------
# Read image rows reliably
# -----------------------------
declare -a image
for y in $(seq 0 $((height - 1))); do
    # Extract hex colors only, ignore alpha channel
    # Ensure exactly $width entries
    line=$(convert "$INPUT" -crop "${width}x1+0+${y}" txt:- \
        | tail -n +2 | awk -v w="$width" '{printf "%s%s", substr($3,1,7),(NR<w?" ":"\n")}')
    image[$y]="$line"
done

# -----------------------------
# Process in half-block rows
# -----------------------------
y=0
while [[ $y -lt $height ]]; do
    y_bottom=$((y+1))
    [[ $y_bottom -ge $height ]] && y_bottom=$y

    # Split top and bottom rows into arrays
    IFS=' ' read -r -a top_row <<< "${image[$y]}"
    IFS=' ' read -r -a bottom_row <<< "${image[$y_bottom]}"

    last_fg=""
    last_bg=""
    run_length=0
    run_seq=""

    for ((x=0; x<width; x++)); do
        fg="${top_row[$x]:-#000000}"
        bg="${bottom_row[$x]:-#000000}"

        fg_rgb=$(convert_from_hex "$fg")
        bg_rgb=$(convert_from_hex "$bg")

        if [[ "$fg_rgb" != "$last_fg" || "$bg_rgb" != "$last_bg" ]]; then
            if [[ $run_length -gt 0 ]]; then
                for ((i=0;i<run_length;i++)); do
                    printf '%b▀' "$run_seq"
                done
            fi
            last_fg="$fg_rgb"
            last_bg="$bg_rgb"
            run_seq="\e[38;2${fg_rgb}m\e[48;2${bg_rgb}m"
            run_length=1
        else
            run_length=$((run_length + 1))
        fi
    done

    # Flush final run
    if [[ $run_length -gt 0 ]]; then
        for ((i=0;i<run_length;i++)); do
            printf '%b▀' "$run_seq"
        done
    fi

    printf '\e[0m\n'
    y=$((y+2))
done
