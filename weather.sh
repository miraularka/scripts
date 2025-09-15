#!/usr/bin/env bash


CACHE="${HOME}/.cache/polybar_weather"
TTL=600
fetch() {
	output=$(curl -s "wttr.in/?format=%t%20-%20%C")
	echo "${output/+}" > "$CACHE"
}
if [[ ! -f "$CACHE" ]] || [[ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -gt $TTL ]]; then
    fetch
fi

echo " - "$(cat $CACHE)
