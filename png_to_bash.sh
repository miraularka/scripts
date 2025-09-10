#!/usr/bin/env bash

convert_from_hex(){
	local hex=$1
	local r=$((16#${hex:1:2}))
	local g=$((16#${hex:3:2}))
	local b=$((16#${hex:5:2}))
	echo -e ";${r};${g};${b}m"
}

if [[ -n $1 ]]; then
	pixels_top=()
	pixels_bottom=()
	width=$(identify -format "%w" $1)
	height=$(identify -format "%h" $1)
	for y in $(seq 0 $(($height - 1))); do
		line=$(convert "$1" -crop "${width}x1+0+${y}" txt:- | tail -n +2 | awk '{print $3}')
		[[ $(( $y % 2 )) -eq 0 ]] && pixels_top+=($line) || pixels_bottom+=($line) ;
		if [[ $(($y % 2)) != 0 ]]; then
			for x in $(seq 0 $(($width - 1))); do
				echo -n -e "\e[38;2"$(convert_from_hex ${pixels_top[$x]})"\e[48;2"$(convert_from_hex ${pixels_bottom[$x]})"▀\e[0m"
			done
			echo ''
			pixels_top=()
			pixels_bottom=()
		fi
	done


else
	echo "Syntax error: Missing <filename>"
fi

