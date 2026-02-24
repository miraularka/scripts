#!/usr/bin/env bash


cleanup(){
	rm /tmp/icon.png
	exit 0
}

msg(){
	convert -size 32x32 xc:transparent -fill WHITE -font \
	${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 \
	-draw 'gravity center text 0 0 "󰴸"' /tmp/icon.png
	dunstify -a system-script -i /tmp/icon.png -r 1337 "Audio Sink Updated:" "$1" 2>/dev/null || true
}

if [[ -z "${1}" ]]; then
	sinks=$(pactl -f json list sinks | jq -r '.[] | .description')
	selection=$(echo "$sinks" | dmenu -i -l 5 -p "Audio Output:")
	name=$(pactl -f json list sinks | jq -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')
	if [ -n "$name" ]; then
		pactl set-default-sink "$name" && msg "$selection"
		case "$name" in *bluez*) icon="󰦢 ";; *hdmi*) icon="󰽟 ";; *) icon=" ";; esac
		echo "$icon" > ${HOME}/.cache/current_sink_icon
	else
		msg "No changes made"
	fi
else
	default_sink_index=$(pactl info | grep "Default Sink" | cut -d ':' -f2 | xargs)
	default_description=$(pactl -f json list sinks | jq -r --arg sink "$default_sink_index" '.[] | select(.name == $sink) | .description')
	msg "$default_description"
fi

cleanup
