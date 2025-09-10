#!/usr/bin/env bash

sound_finish=${HOME}/Scripts/Sounds/timer_finish.wav
sound_cancel=${HOME}/Scripts/Sounds/timer_cancel.wav

cleanup(){
	rm /tmp/polybar_timer
	kill -TERM $(pgrep -f timer.sh)
	exit 0
}

msg(){
	convert -size 32x32 xc:transparent -fill WHITE -font \
	${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 \
	 -draw 'gravity center text 0 0 "󱎫"' /tmp/icon.png
	notify-send -i /tmp/icon.png -t "$2" -r 1339 "$1"
}

cancel(){
	msg "Timer stopped early" 3000
	play --volume 0.4 "$sound_cancel"
	cleanup
}

timer(){
	while [[ $seconds -gt 0 ]]; do
		mins=$(printf "%02d" $((seconds / 60)))
		secs=$(printf "%02d" $((seconds % 60)))
		echo "$mins:$secs" > /tmp/polybar_timer
		sleep 1
		((seconds--))
	done
	msg "Times Up!" 30000
	play --volume 0.6 "$sound_finish"
	cleanup
}

menu(){
	min="$(echo '' | dmenu -p "Minutes: " <&-)"
	seconds=$((min * 60))
	timer
}

case "$1" in
	-menu) menu ;;
	-cancel) cancel ;;
	*) [[ -f /tmp/polybar_timer ]] && cat /tmp/polybar_timer || echo "%{F#ffb52a} 󱎫 %{F-}" ;;
esac
