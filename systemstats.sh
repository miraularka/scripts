#!/usr/bin/env bash
drive='/dev/nvme0n1p2'

make_bar(){
	full=$(($1*40/100))
	for ((i=1;i<=full;i++)); do
		bar=$bar""
	done
	empty=$((40-full))
	for ((i=1;i<=empty;i++)); do
		bar=$bar""
	done
	echo $bar
}

if [[ -z "${1}" ]]; then
	drivespace=$(df -l -h | grep $drive | awk '{printf "%04.4s",$5}')
	memory=$(free -m | awk 'NR==2{printf "%3.0f%%", $3*100/$2}')
	cpu=$(top -bn2 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" \
	 | awk 'NR==2{printf "%3.0f%%", 100-$1}')
	echo "%{F#ffb52a}  %{F-}${memory}  %{F#ffb52a} %{F-}${cpu}" \
	" %{F#ffb52a}󱛟 %{F-}${drivespace}"
else
	drive_size=$(df -l -h | grep $drive | awk '{print $2}') && drive_size="${drive_size::-1}"
	drive_used=$(df -l -h | grep $drive | awk '{print $3}') && drive_used="${drive_used::-1}"
	drive_free=$(df -l -h | grep $drive | awk '{print $4}') && drive_free="${drive_free::-1}"
	drive_percent_used=$((drive_used*100/drive_size))

	output="\n<b>󱛟 ${drive}</b>"
	output=$output"\nUsed Drive Space:		 <b>${drive_used}G</b>"
	output=$output"\nAvailable Drive Space:		<b>${drive_free}G</b>"
	output=$output"\nTotal Drive Space:		<b>${drive_size}G</b>"
	drive_bar=$(make_bar drive_percent_used)
	[[ drive_free -le 5 ]] && drive_bar=$drive_bar"" || drive_bar=$drive_bar""
	output=$output"\n"$drive_bar

	mem_size=$(free -m | awk 'NR==2{printf $2}')
	mem_used=$(free -m | awk 'NR==2{printf $3}')
	mem_free=$(free -m | awk 'NR==2{printf $4}')
	mem_percent_used=$((mem_used*100/mem_size))

	output=$output"\n\n<b> Memory</b>"
	output=$output"\nUsed Memory:			<b>${mem_used}M</b>"
	output=$output"\nAvailable Memory:		<b>${mem_free}M</b>"
	output=$output"\nTotal Memory:			<b>${mem_size}M</b>"
	mem_bar=$(make_bar mem_percent_used)
	[[ mem_free -le 5 ]] && mem_bar=$mem_bar"" || mem_bar=$mem_bar""
	output=$output"\n"$mem_bar

	notify-send "System Stats" "${output}" -t 30000
fi
