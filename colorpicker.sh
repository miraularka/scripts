#!/usr/bin/env bash

cleanup(){
	rm "$TMP"
	rm /tmp/icon.png
	rm nohup.out
}

msg(){
	convert -size 32x32 xc:transparent -fill $HEX -font \
	${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 \
	-draw 'gravity center text 0 0 ""' /tmp/icon.png
	dunstify -a system-script -i /tmp/icon.png "Color Selector" "$1" 2>/dev/null || true
}

TMP="/tmp/color.png"
import -window root "$TMP"
mousex=$(xdotool getmouselocation | awk '{print $1}' | sed 's/^.\{2\}//')
mousey=$(xdotool getmouselocation | awk '{print $2}' | sed 's/^.\{2\}//')
HEX=$(convert "$TMP" -format "#%[hex:p{$mousex,$mousey}]" info:)
RGB=$(printf "%d,%d,%d" 0x${HEX:1:2} 0x${HEX:3:2} 0x${HEX:5:2})

options () { \
	choice=$(echo -e "HEX\nRGB" | dmenu -l 10 -i -p "Select Format: ")
	[ $? -ne 0 ] && exit ;
	case $choice in
		'HEX') COLOR="$HEX" ;;
		'RGB') COLOR="$RGB" ;;
		*) ;;
	esac
}
options
msg "$COLOR"
printf "%s" "$COLOR" | xclip -i -selection clipboard
cleanup
