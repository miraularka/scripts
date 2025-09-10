#!/usr/bin/env bash

length=10



vol=$(amixer sget Master | grep 'Right:' | awk -F'[][]' '{print $2}')
vol=${vol:0:-1}
output="%{F#ffb52a}"$(cat ${HOME}/.cache/current_sink_icon)

[[ $vol -gt 0 ]] && begin="%{F#7cc7f2} " || begin="%{F#f27c7c} "
[[ $vol -lt 100 ]] && final="" || final=""

volume-bar() {
	local i
	local num_bars=$((vol * length / 100))
	output+=$begin
	for ((i = 0; i < num_bars; i++)); do output+=''; done
	for ((i = num_bars; i < length; i++)); do output+=''; done
	output+=$final'%{F-}' 
}

volume-bar
echo "$output"
