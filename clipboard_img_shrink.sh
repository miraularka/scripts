#!/usr/bin/env bash

#Script to change size of clipboard image for easier pasting on Discord/etc by Mirau! Updated Jan 9th, 2026

set -euo pipefail

# Config
MAX_SIZE="500x500"
NOTICE_OK="Image resized and copied to clipboard!"
NOTICE_NO_IMAGE="No image found on clipboard!"

TMPDIR="$(mktemp -d)"
SRC="$TMPDIR/src.png"
OUT="$TMPDIR/out.png"

cleanup() {
	rm -rf "$TMPDIR"
}
trap cleanup EXIT

# Notification
notify() {
	dunstify -i "$OUT" -r 1340 "Clipboard Image Resize" "$1" 2>/dev/null || true
}

# Clipboard Image Check
if ! xclip -selection clipboard -t image/png -o >"$SRC" 2>/dev/null; then
	notify "$NOTICE_NO_IMAGE"
	exit 0
fi

# Resize
convert "$SRC" -resize "$MAX_SIZE>" "$OUT"

# Clipboard Update
xclip -selection clipboard -t image/png -i "$OUT"

notify "$NOTICE_OK"
