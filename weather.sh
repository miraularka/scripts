#!/usr/bin/env bash


CACHE="${HOME}/.cache/polybar_weather"
TTL=600
fetch() {
	curl -s "wttr.in/?format=2" > "$CACHE"
}
if [[ ! -f "$CACHE" ]] || [[ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -gt $TTL ]]; then
    fetch
fi
condition=$(awk '{$1=""; sub(/^ /, ""); print}' "$CACHE")

case $condition in
	"Partly cloudy") ICON="PC" ;;
	"Light rain") ICON="LR" ;;
	*) ICON="" ;;
esac

#echo "%{F#ffb52a}$ICON  %{F-}$(awk '{print $1}' "$CACHE")"

read -r word1 word2 rest <<< $(cat "$CACHE")
echo "%{F#ffb52a}$word1 %{F-} ${word2} $rest"
