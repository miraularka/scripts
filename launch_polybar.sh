#!/usr/bin/env bash

pkill polybar
polybar -c ~/.config/polybar/config.ini main &
