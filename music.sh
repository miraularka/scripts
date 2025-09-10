#!/usr/bin/env bash

player=$(echo -n $(playerctl metadata | awk '{print $1}'))
player=$(echo $player | awk '{print $1}')
if [[ $player == 'firefox' ]]; then
	output=$(echo  "%{F#ffb52a} %{F-}" $(playerctl metadata title) | (input=$(cat); echo "$input"))
elif [[ $player == 'cmus' ]]; then
	output=$(echo "%{F#ffb52a} %{F-}" $(playerctl metadata cmus:stream_title) | (input=$(cat); echo "$input"))
else
	output=$(echo "- No Audio Playing -")
fi
[[ ${#output} -gt 60 ]] && output="${output:0:57}..." || output="$output"
echo "$output"
