#!/usr/bin/env bash

word=${1:-$(xclip -o -selection primary 2>/dev/null || wl-paste 2>/dev/null)}

[[ -z "$word" || "$word" =~ [\/] ]] && notify-send "Dictionary Error" "Can not parse selection" && exit 0
