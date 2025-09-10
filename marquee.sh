#!/usr/bin/env bash

text="$1"
length="$2"
delay=1

if [[ -z "$text" || -z "$length" || "$length" -le 0 ]]; then
	echo "Usage: $0 <text> <length>"
	exit 1
fi

text="$text$text"
text_length=${#text}

i=0
while true; do
	start=$(( i % ${#text} ))
	if (( start + length <= text_length )); then
		echo -ne "${text:start:length}\r"
	else
		part1=${text:start}
		part2=${text:0:length - ${#part1}}
		echo -ne "${part1}${part2}\r"
	fi
	sleep "$delay"
	((i++))
done
