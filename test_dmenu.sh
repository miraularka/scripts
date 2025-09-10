#!/usr/bin/env bash

#query="$( echo "" | dmenu -p "Search: " <&- )"
#[ -n "${query}" ] && echo "${query}" &


#choice="$(find ~/Pictures - type f -name "*.png" | sort -n | dmenu -i -l 10 -p "Wallpaper:")"
#[ -n "${choice}" ] && echo "You selected ${choice}" &


for a in *.png; do echo -en "$a\0icon\x1f$a\n" ; done | rofi -dmenu
