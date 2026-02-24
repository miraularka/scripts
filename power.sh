#!/usr/bin/env bash

#Jim's power menu - started out as just a way to logout/shutdown; added common options over time

options () { \
	choice=$(echo -e "Color Picker (Super+C)\nShrink Image (500px max)\nWatermark Image (WCF)\nDownload Mp3\nNotes\nAudio Output Selector\n\nLogout\nShutdown" | dmenu -l 10 -i -p "Power Menu: ")
	[ $? -ne 0 ] && exit ;
	case $choice in
		'Color Picker (Super+C)') ~/Scripts/colorpicker.sh ;;
		'Shrink Image (500px max)') ~/Scripts/clipboard_img_shrink.sh ;;
		'Watermark Image (WCF)') ~/Scripts/watermark_wcf.sh ;;
		'Download Mp3') ~/Scripts/yt-mp3.sh ;;
		'Notes') ~/Scripts/notes.sh ;;
		'Audio Output Selector') ~/Scripts/audio_sink_selector.sh ;;
		'Logout') i3-msg exit ;;
		'Shutdown') systemctl poweroff ;;
		*) ;;
	esac
}

options
