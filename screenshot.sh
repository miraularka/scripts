#!/usr/bin/env bash

#export DISPLAY=:0
current=$(date +%H-%M-%S-%d-%m-%Y).png
shot="${HOME}/Pictures/Screenshots/${current}"

if [[ -z "${1}" ]]; then
		import -window root "${shot}" || exit 0 # If no argument, full screen (all monitors)
else
		import "${shot}" || exit 0 # Custom selection, or click a window
fi
xclip -selection clipboard -t image/png -i "${shot}"

convert -size 32x32 xc:transparent -fill black -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 -draw 'gravity center text 0 0 "󰹑"' /tmp/test.png

if [[ $(dunstify "Screenshot ${current} taken successfully!" -i /tmp/test.png -A default,default) == default ]]; then
	thunar ${HOME}/Pictures/Screenshots
fi
rm /tmp/test.png
rm nohup.out
