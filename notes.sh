#!/usr/bin/env bash

dir=~/Documents/Notes/

notification () { \
	convert -size 32x32 xc:transparent -fill WHITE -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf  \
	-pointsize 32 -draw 'gravity center text 0 0 ""' /tmp/icon.png
	notify-send -i /tmp/icon.png "$1" "$2"
	rm /tmp/icon.png
}

newnote () { \
	name="$(echo "" | dmenu -p "Enter a name (no spaces): " <&-)"
	touch $dir$name".txt" >/dev/null 2>&1
	notification "New Note Created:" $name
	kitty nano $dir$name".txt" >/dev/null 2>&1
}

delnote () { \
	name=$(echo -e "$(for f in $(ls -t1 "$dir"); do echo "${f%.txt}"; done)" \
	| dmenu -l 10 -i -p "Choose a note to delete: ")
	[ $? -ne 0 ] && exit ;
	rm $dir$name".txt"
	notification "Note Deleted:" $name
}

selected () { \
	choice=$(echo -e " New\n󰆴 Delete\n$(for f in $(ls -t1 "$dir"); do echo "${f%.txt}"; done)" \
	 | dmenu -l 10 -i -p "Choose note or create new: ")
	[ $? -ne 0 ] && exit ;
	case $choice in
		' New') newnote ;;
		'󰆴 Delete') delnote ;;
		*) kitty nano $dir$choice".txt" >/dev/null 2>&1 ;;
	esac
}

selected
