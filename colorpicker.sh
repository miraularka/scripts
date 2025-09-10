#!/usr/bin/env bash

#export DISPLAY=:0
TMP="/tmp/color.png"

import -window root "$TMP"
mousex=$(xdotool getmouselocation | awk '{print $1}' | sed 's/^.\{2\}//')
mousey=$(xdotool getmouselocation | awk '{print $2}' | sed 's/^.\{2\}//')
HEX=$(convert "$TMP" -format "#%[hex:p{$mousex,$mousey}]" info:)
convert -size 32x32 xc:transparent -fill $HEX -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 -draw 'gravity center text 0 0 ""' /tmp/icon.png
notify-send -i /tmp/icon.png $HEX # set the tmp img as the notif icon
echo "$HEX" | xclip -i -selection clipboard # copy to clip
rm "$TMP"
rm /tmp/icon.png
rm nohup.out
