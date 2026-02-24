#!/usr/bin/env bash

target_dir="/mnt/mince/data1/Music/unsorted"
output_template="${target_dir}/%(title)s.%(ext)s"

download() {
    mkdir -p "$target_dir"

	filename="$(yt-dlp -x --audio-format mp3 --audio-quality 0 \
    --js-runtimes node \
    -o "$output_template" \
    --print after_move:filepath \
    "$url")"

    if [[ -n "$filename" && -f "$filename" ]]; then
        action=$(msg "Download Complete" "$filename")
        if [[ "$action" == "default" ]]; then
        	thunar /mnt/mince/data1/Music/unsorted
        fi
    else
        msg "Download Failed" "$url"
    fi
}


msg() {
    icon="/tmp/icon.png"

    convert -size 32x32 xc:transparent \
        -fill WHITE \
        -font "${HOME}/.fonts/GohuFont14NerdFont-Regular.ttf" \
        -pointsize 32 \
        -draw 'gravity center text 0 0 ""' "$icon"

    dunstify -a system-script -i "$icon" -A default,default -r 1341 "$1" "$2" 2>/dev/null || true
    rm -f "$icon"
}

enterurl() {
    clipboard="$(xclip -selection clipboard -o 2>/dev/null)"
    url="$(printf '%s\n' "$clipboard" | dmenu -l 1 -p "Enter YouTube URL:")"

    [[ -z "$url" ]] && exit 0

    msg "Downloading..." "$url"
    download
}

enterurl
