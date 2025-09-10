#!/usr/bin/env bash

packages=$(apt list --upgradable 2>/dev/null | tail -n +2 | awk '{if (length($0) > 30) {print substr($0, 0, 31)"..."} else print $0}')
count=$(echo ${packages} | wc -l)
count=$(($count - 1))
if [[ $count > 0 ]]; then
	icon="󰏔"
	title="Available Package Upgrades"
else
	icon="󰏓"
	title="All Packages Current"
fi

if [[ -z "${1}" ]]; then
	echo "%{F#ffb52a}${icon} %{F-}${count}"
else
	convert -size 32x32 xc:transparent -fill white -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 -draw "gravity center text 0 0 '${icon}'" /tmp/icon.png
	notify-send "${title}" "${packages}" -i /tmp/icon.png
	rm /tmp/icon.png
fi
