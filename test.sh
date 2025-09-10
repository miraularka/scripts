#!/usr/bin/env bash

#Bash test script template thing

[[ -n $1 ]] && len=${#1}
for  (( i=0; i<$len; i++)); do
	bar=$bar"─"
done
echo "╭"$bar"╮"
echo "│"$1"│"
echo "╰"$bar"╯"

