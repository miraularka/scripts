#!/usr/bin/env bash
#Place source image named temp
dir=/home/jim/Pictures/WCF/
if perl -e 'exit ((localtime)[8])' ; then
	zone=PST
else
	zone=PDT
fi
line1="- WCF GENERAL -"
line2=$(TZ=":US/Pacific" date +%I:%M%p)
echo "$line1"
echo "$line2 $zone"
dest=$dir$line2.png
[[ $(date +%l) -lt 10 ]] && line2="${line2:1}"

if [[ -n $1 ]]; then
	# resize the initial image to a consistent 500x500 pixels
	convert $dir'temp.'$1 -scale 500X500 $dest
	# we draw shadows first on the bottom
	convert -size 500X500 xc:transparent -font 'Yoster-Island-Regular' -pointsize 24 -gravity southeast -fill black -annotate +50+10 "$line2 $zone" -blur 2x4 $dest +swap -composite $dest
	convert -size 500X500 xc:transparent -font 'Yoster-Island-Regular' -pointsize 24 -gravity southeast -fill black -annotate +20+32 "$line1" -blur 2x4 $dest +swap -composite $dest
	# proper text on top
	convert -size 500X500 xc:transparent -font 'Yoster-Island-Regular' -pointsize 24 -gravity southeast -fill white -stroke black -annotate +52+12 "$line2 $zone" $dest +swap -composite $dest
	convert -size 500X500 xc:transparent -font 'Yoster-Island-Regular' -pointsize 24 -gravity southeast -fill white -stroke black -annotate +22+34 "$line1" $dest +swap -composite $dest
	# copy the output to the clipboard right away
	xclip -selection clipboard -t image/png -i $dest
else
	echo "Append a filetype (jpg,png,etc)"
fi
