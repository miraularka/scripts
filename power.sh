#!/usr/bin/env bash

#Jim's power menu - started out as just a way to logout/shutdown; added common options over time

options () { \
	choice=$(echo -e "Color Picker (Super+C)\nWatermark Image (WCF)\n\nAudio Output\n\nLogout\nShutdown" | dmenu -l 10 -i -p "Power Menu: ")
	[ $? -ne 0 ] && exit ;
	case $choice in
		'Color Picker (Super+C)') ~/Scripts/colorpicker.sh ;;
		'Watermark Image (WCF)') ~/Scripts/watermark_wcf.sh ;;
		'Audio Output') ~/Scripts/audio_sink_selector.sh ;;
		'Logout') i3-msg exit ;;
		'Shutdown') systemctl poweroff ;;
		*) ;;
	esac
}

options
