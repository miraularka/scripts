#!/usr/bin/env bash

echo "Testing passing variables through functions in bash"
echo "---------------------------------------------------"

notification () { \
	notify-send "$1" "$2"
}
title="Hello World"
body="There it is"
notification "Hello World 2" "$body"
