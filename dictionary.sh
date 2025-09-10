#!/usr/bin/env bash

menu(){
	word="$(echo '' | dmenu -p "Word: " <&-)"
}

from_clipboard(){
	word=${1:-$(xclip -o -selection primary 2>/dev/null || wl-paste 2>/dev/null)}
}

case "$1" in
	-menu) menu ;;
	*) from_clipboard ;;
esac

convert -size 32x32 xc:transparent -fill white -font ${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf \
	 -pointsize 32 -draw 'gravity center text 0 0 "󰺄"' /tmp/icon.png

[[ -z "$word" || "$word" =~ [\/] ]] && notify-send -i /tmp/icon.png "Dictionary Error" \
	"Can not parse selection" && exit 0

query=$(curl -s --connect-timeout 5 --max-time 10 \
	 "https://api.dictionaryapi.dev/api/v2/entries/en_US/$word")

[ $? -ne 0 ] && notify-send -i /tmp/icon.png "Dictionary Error" "Unable to connect to dictionary" && exit 1

[[ "$query" == *"No Definitions Found"* ]] && notify-send -i /tmp/icon.png "$word" "No Definitions Found" && exit 0

def=$(echo "$query" | jq -r '.[].meanings[] | {pos: .partOfSpeech, def: .definitions[0].definition} | "\n <i>\(.pos).</i>\n \(.def)"')

notify-send -i /tmp/icon.png -t 30000 "«$word» 󱞣" "$def"
rm /tmp/icon.png
