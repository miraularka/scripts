#!/usr/bin/env bash

show_error(){
	echo "Error>> "$1
	exit 1
}

if [[ -n $1 ]]; then
	echo "Counting pixels..."
	width=$(identify -format "%w" $1)
	height=$(identify -format "%h" $1)
	p_count=0
	c_count=0
	for y in $(seq 0 $(($height - 1))); do
		for x in $(seq 0 $(($width - 1))); do
			pixel=$(convert "$1" -format "%[hex:p{${x},${y}}]" info:)
			[[ "$pixel" != "00000000" ]] && p_count=$((p_count+1))
		done
	done

	echo "Image size is: ${width}x${height}"
	total_count=$(($width * $height))
	echo "Colored pixels: ${p_count}/${total_count}"
	pixel_time=$(($p_count / 2))
	pixel_hours=$(($pixel_time / 60))
	pixel_min=$(($pixel_time % 60))
	echo "Total required pixel charge time is an estimated: ${pixel_hours}hours and ${pixel_min}minutes"
else
	show_error "No filename supplied"
fi
