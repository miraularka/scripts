#!/usr/bin/env bash

#Select a wallpaper from the wallpapers dir and rename the reference file

msg(){
	convert -size 32x32 xc:transparent -fill WHITE -font \
	${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf -pointsize 32 \
	-draw 'gravity center text 0 0 "󰸉"' /tmp/icon.png
	dunstify -a system-script -i /tmp/icon.png -r 1342 "Wallpaper Status:" "$1" 2>/dev/null || true
	rm /tmp/icon.png
}

dir=~/Pictures/Wallpapers
count="$(find ${dir} -type f \( -name '*.png' -or -name '*.jpg' \) -printf x | wc -c)"
choice="$(find ${dir} -type f \( -name '*.png' -or -name '*.jpg' \) -printf '%f\n' | sort -n | dmenu -i -l 10 -p "Select Wallpaper (${count})")"
[ -n "${choice}" ] && echo "${dir}/${choice}" >| ${dir}/current_wallpaper &
feh --bg-fill $(cat ${dir}/current_wallpaper)


msgid="1338"
if [[ -z ${choice} ]]; then
	msg "No changes have been made"
else
	msg "Set to ${choice}"
fi
