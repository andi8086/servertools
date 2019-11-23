#!/bin/bash
DISKORDER="sdo sdq sdk sdp sdg sdi sdf sdh sdb sda sdd sdc sdn sdl sdj sdm"
DISKCOLS=4

j=0

for d in $DISKORDER; do
	j=$((j+1))
	echo -n "     $d       "
	[[ $((j % $DISKCOLS)) == 0 ]] && echo && echo
done

for d in $DISKORDER; do
	j=$((j+1))
	SERIAL=$(lsblk -o KNAME,SERIAL | grep $d | head -n1 | awk '{print $2}')

	if zpool status 2>/dev/null | grep -q $SERIAL"  "ONLINE; then
		echo -n -e "\e[92m"
	else		
		echo -n -e "\e[91m"
	fi
	echo -n "   $SERIAL    "
	[[ $((j % $DISKCOLS)) == 0 ]] && echo && echo
done
echo -n -e "\e[0m"
for d in $DISKORDER; do
	j=$((j+1))
	CELSIUS=$(smartctl -a /dev/$d | grep ^194 | awk '{print $10}')
	if [ $CELSIUS -le 40 ]; then
		echo -n -e "\e[92m"
	elif [ $CELSIUS -le 50 ]; then
		echo -n -e "\e[93m"
	else
		echo -n -e "\e[91m"
	fi

	echo -n -e "   $CELSIUS \xc2\xb0C      "
	[[ $((j % $DISKCOLS)) == 0 ]] && echo && echo
done
echo -n -e "\e[0m"
