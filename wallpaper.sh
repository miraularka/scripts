#!/usr/bin/env bash

#Select a wallpaper from the wallpapers dir and rename the reference file

dir=~/Pictures/Wallpapers
count="$(find ${dir} -type f \( -name '*.png' -or -name '*.jpg' \) -printf x | wc -c)"
choice="$(find ${dir} -type f \( -name '*.png' -or -name '*.jpg' \) -printf '%f\n' | sort -n | dmenu -i -l 10 -p "Select Wallpaper (${count})")"
[ -n "${choice}" ] && echo "${dir}/${choice}" >| ${dir}/current_wallpaper &
feh --bg-fill $(cat ${dir}/current_wallpaper)

convert -size 32x32 xc:transparent -fill WHITE -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 -draw 'gravity center text 0 0 "󰸉"' /tmp/icon.png
msgid="1338"
if [[ -z ${choice} ]]; then
	notify-send -i /tmp/icon.png -r $msgid "Wallpaper Unchanged" "No changes have been made"
else
	notify-send -i /tmp/icon.png -r $msgid "Wallpaper Updated" "Set to ${choice}"
fi
rm /tmp/icon.png
