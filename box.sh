#!/usr/bin/env bash

border=0
help=0
max_len=70
chunk=""
result=()
bar_len=0

while getopts ":b:h" opt; do
	case "$opt" in
		b) border="$OPTARG" ;;
		h) help=1 ;;
		/?) echo "Unknown option: -$OPTARG" >&2; exit 1 ;;
	esac
done

shift $((OPTIND -1))

[[ "$help" -eq 1 ]] && echo "Usage: $0 [-b number] [-h] <string>" && exit 0

style_border(){
	case "$1" in
		0) nw=".";ne=".";sw="'";se="'";h="-";v="|";;
		1) nw="╭";ne="╮";sw="╰";se="╯";h="─";v="│";;
		2) nw="┏";ne="┓";sw="┗";se="┛";h="━";v="┃";;
	esac
}
style_border "$border"

for word in $1; do
	if [ ${#chunk} -gt 0 ] && [ $(( ${#chunk} + ${#word} + 1 )) -gt $max_len ]; then
		result+=("$chunk")
		chunk="$word"
	else
		if [ -z "$chunk" ]; then
			chunk="$word"
		else
			chunk="$chunk $word"
		fi
	fi
done

[ -n "$chunk" ] && result+=("$chunk")
for part in "${result[@]}"; do [[ ${#part} -gt $bar_len ]] && bar_len=${#part} ; done
for (( i=0; i<$bar_len+2; i++)); do bar=$bar$h; done

echo $nw$bar$ne
for part in "${result[@]}"; do
	padding=""
	len=$(($bar_len - ${#part}))
	for (( i=0; i<$len; i++)); do padding="$padding "; done
	echo "$v $part$padding $v"
done
echo $sw$bar$se
