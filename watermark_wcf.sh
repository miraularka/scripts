#!/usr/bin/env bash

#WCF Watermark Image Script by Mirau! Updated Dec 8th, 2025

#--- Config
DIR="$HOME/Pictures/WCF"
TEMP="$DIR/temp.png"
FONT="Yoster-Island-Regular"
SIZE="500x500"
LINE1="- WCF GENERAL -"
LINE2=$(TZ="US/Pacific" date "+%-I:%M%p %Z")
DEST="$DIR/${LINE2}.png"

NOTICE_NO_IMAGE="No image found on clipboard!"
NOTICE_OK="Watermark applied and copied to clipboard!"


#--- Functions

notification() {
	if [[ $(dunstify "$1" -i "$TEMP" -A default,default) == default ]]; then
		thunar "$DIR"
	fi
}

apply_watermark() {
	echo "[INFO] Resizing and applying watermark"
	WOPT=(-size "$SIZE" xc:transparent -font "$FONT" -pointsize 24 -gravity southeast)

	# Build layers onto image with one call
	convert "$TEMP" -resize "$SIZE" \
		\
		\( "${WOPT[@]}" -fill black -annotate +50+10 "$LINE2" -blur 2x4 \) -composite \
		\( "${WOPT[@]}" -fill black -annotate +20+32 "$LINE1" -blur 2x4 \) -composite \
		\( "${WOPT[@]}" -fill white -stroke black -annotate +52+12 "$LINE2" \) -composite \
		\( "${WOPT[@]}" -fill white -stroke black -annotate +22+34 "$LINE1" \) -composite \
		"$DEST"

	# Copy output to clipboard
	xclip -selection clipboard -t image/png -i "$DEST"

	echo "[INFO] $NOTICE_OK"
}

#--- Main Check Loop

MIME_TYPES=(
	image/png
	image/jpeg
	image/jpg
	image/webp
	image/bmp
	image/tiff
)

FOUND=0
TEMP_ANY="$DIR/temp_any"

for mime in "${MIME_TYPES[@]}"; do
	if timeout 0.3 xclip -selection clipboard -t "$mime" -o > "$TEMP_ANY" 2>/dev/null; then
		FOUND=1
		break
	fi
done

if [[ $FOUND -eq 1 ]]; then
	echo "[INFO] Image found on clipboard (detected $mime)"
	convert "$TEMP_ANY" "$TEMP"
	rm -f "$TEMP_ANY"

	apply_watermark
	notification "$NOTICE_OK"
else
	notification "$NOTICE_NO_IMAGE"
fi

