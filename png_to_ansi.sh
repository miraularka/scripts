#!/usr/bin/env bash
# png2ansi_optimized_fixed.sh
# Converts a PNG to optimized ANSI output with optional file output
# Usage:
#   ./png2ansi_optimized_fixed.sh image.png            # prints to terminal
#   ./png2ansi_optimized_fixed.sh image.png output.ans # saves to file

# -----------------------------
# Convert #RRGGBB hex to RGB ANSI
# -----------------------------
convert_from_hex() {
    local hex=$1
    local r=$((16#${hex:1:2}))
    local g=$((16#${hex:3:2}))
    local b=$((16#${hex:5:2}))
    printf ';%d;%d;%dm' "$r" "$g" "$b"
}

# -----------------------------
# Validate input
# -----------------------------
if [[ -z $1 ]]; then
    printf 'Syntax error: Missing <filename>\n'
    exit 1
fi

INPUT="$1"
OUTPUT="$2"

# Redirect output to file if provided
if [[ -n "$OUTPUT" ]]; then
    exec > "$OUTPUT"
fi

pixels_top=()
pixels_bottom=()
width=$(identify -format "%w" "$INPUT")
height=$(identify -format "%h" "$INPUT")

# Track last emitted foreground/background to reduce redundant sequences
last_fg=""
last_bg=""

for y in $(seq 0 $((height - 1))); do
    # Extract one line of pixels
    line=$(convert "$INPUT" -crop "${width}x1+0+${y}" txt:- | tail -n +2 | awk '{print $3}')

    if [[ $((y % 2)) -eq 0 ]]; then
        pixels_top=($line)
    else
        pixels_bottom=($line)

        for x in $(seq 0 $((width - 1))); do
            fg=$(convert_from_hex "${pixels_top[$x]}")
            bg=$(convert_from_hex "${pixels_bottom[$x]}")

            seq=""

            # Emit foreground color only if changed
            if [[ "$fg" != "$last_fg" ]]; then
                seq="\e[38;2${fg}"
                last_fg="$fg"
            fi

            # Emit background color only if changed
            if [[ "$bg" != "$last_bg" ]]; then
                seq="${seq}\e[48;2${bg}"
                last_bg="$bg"
            fi

            # Always print a block; prepend ANSI sequence if needed
            if [[ -n "$seq" ]]; then
                printf '%b▀' "$seq"
            else
                printf '▀'
            fi
        done

        # End of line: reset colors and add newline
        printf '\e[0m\n'

        # Reset last_fg/last_bg so next line emits all colors
        last_fg=""
        last_bg=""

        pixels_top=()
        pixels_bottom=()
    fi
done
