#!/usr/bin/env bash

### Config
title=""
icon=""
width=30
delay=0.4
count=0
nbsp=$'\u00A0'


### Check for changes
fetch() {
	player=$(playerctl metadata --format '{{playerName}}' 2>/dev/null)
	if [[ $player == "firefox" ]]; then
		new_title=$(playerctl metadata title 2>/dev/null)
		new_icon="%{F#ffb52a} %{F-}"

	elif [[ $player == "cmus" ]]; then
		new_title=$(playerctl metadata 'xesam:title' 2>/dev/null)
		new_icon="%{F#ffb52a} %{F-}"

	elif [[ -n $player ]]; then
		new_title=$(playerctl metadata title 2>/dev/null)
		new_icon="%{F#ffb52a} %{F-}"

	else
		new_title="- No Audio Playing"
		new_icon="%{F#ffb52a}󰝛 ${F-}"
	fi
	if [[ $new_title != $title ]]; then
		title="${new_title}"
		icon="${new_icon}"
		scroll_count=0
		scroll_text=$(echo "${title} ${title} ${title} " | tr -cd '\11\12\15\40-\176')
		scroll_len=$(printf "%s" "$scroll_text" | wc -m)
		i=0
	fi
}

### Initialize the title and icon
fetch

### Now Playing Loop
while true; do
	((count++))
	if ((count==10)); then
		fetch
		count=0
	fi

	### Scroll Logic
	start=$(( i % scroll_len ))
	output=$(printf "%s" "$scroll_text" | cut -c $((start + 1))-$((start + width)))
	printf "%s %s\n" "$icon" "$output"
	sleep "$delay"
	((i++))
	(( i == (${#title}+1) )) && i=0
done
