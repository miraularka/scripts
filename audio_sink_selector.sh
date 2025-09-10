#!/usr/bin/env bash

convert -size 32x32 xc:transparent -fill WHITE -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 -draw 'gravity center text 0 0 "󰴸"' /tmp/icon.png
msgid="1337"

if [[ -z "${1}" ]]; then
	sinks=$(pactl -f json list sinks | jq -r '.[] | .description')
	selection=$(echo "$sinks" | dmenu -i -l 5 -p "Audio Output:")
	name=$(pactl -f json list sinks | jq -r --arg sink_pretty_name "$selection" '.[] | select(.description == $sink_pretty_name) | .name')
	if [ -n "$name" ]; then
		pactl set-default-sink "$name" && notify-send -i /tmp/icon.png -r $msgid "Audio Output Changed:" "$selection"
		[[ "$name" == *"hdmi"* ]] && icon="󰽟 " || icon=" "
		echo "$icon" > ${HOME}/.cache/current_sink_icon
	else
		notify-send -i /tmp/icon.png -r $msgid "Audio Output Unchanged" "No changes made"
	fi
else
	default_sink_index=$(pactl info | grep "Default Sink" | cut -d ':' -f2 | xargs)
	default_description=$(pactl -f json list sinks | jq -r --arg sink "$default_sink_index" '.[] | select(.name == $sink) | .description')
	notify-send -i /tmp/icon.png -r $msgid "Current Audio Sink" "$default_description"
fi

rm /tmp/icon.png
