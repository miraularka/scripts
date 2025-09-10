#!/usr/bin/env bash

info(){
	echo "info"
}

fdate(){
	icon='%{F#ffb52a} %{F-}'
	day=$(date +%a)
	case $day in
		Sun) day="Dimanche" ;;
		Mon) day="Lundi" ;;
		Tue) day="Mardi" ;;
		Wed) day="Mercredi" ;;
		Thu) day="Jeudi" ;;
		Fri) day="Vendredi" ;;
		Sat) day="Samedi" ;;
		*) day="???" ;;
	esac
	month=$(date +%b)
	case $month in
		Jan) month="Janvier" ;;
		Feb) month="Février" ;;
		Mar) month="Mars" ;;
		Apr) month="Avril" ;;
		May) month="Mai" ;;
		Jun) month="Juin" ;;
		Jul) month="Julliet" ;;
		Aug) month="Août" ;;
		Sep) month="Septembre" ;;
		Oct) month="Octobre" ;;
		Nov) month="Novembre" ;;
		Dec) month="Décembre" ;;
	esac
	echo $icon $day', '$month $(date +'%d - %l:%M%P')
}

case "$1" in
	-info) info ;;
	*) fdate ;;
esac
