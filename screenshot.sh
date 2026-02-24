#!/usr/bin/env bash

#export DISPLAY=:0
current=$(date +%H-%M-%S-%d-%m-%Y).png
shot="${HOME}/Pictures/Screenshots/${current}"

cleanup(){
	rm nohup.out
	exit 0
}

msg(){
	convert -size 32x32 xc:transparent -fill black -font \
	${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 \
	-draw 'gravity center text 0 0 "󰹑"' /tmp/icon.png
	dunstify -a system-script -i /tmp/icon.png -A default,default "Screenshot:" "$1" 2>/dev/null || true
	rm /tmp/icon.png
}

if [[ -z "${1}" ]]; then
		import -window root "${shot}" || exit 0 # If no argument, full screen (all monitors)
else
		import "${shot}" || exit 0 # Custom selection, or click a window
fi
xclip -selection clipboard -t image/png -i "${shot}"


action=$(msg "${current} taken successfully!\n\n󰳽 Middle-click to open directory")
if [[ "$action" == "default" ]]; then
	thunar ${HOME}/Pictures/Screenshots
fi

cleanup
