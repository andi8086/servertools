#!/bin/bash

SATA_CTRLS=$(lspci | grep -i sata)
CTRL_BUS=$(lspci | grep -i sata | awk '{ print $1 }')

DISKS=$(find /sys/devices/pci0000* -name unique_id 2>/dev/null)

for ATANUM in $(seq 1 32); do
	HOSTNUM=$(dirname $(grep ^$ATANUM\$ $DISKS) 2>/dev/null)
	[ -z $HOSTNUM ] || {
		HOSTNUM=$(basename $HOSTNUM | sed 's/host//')
		INFO=$(dmesg | grep [[:space:]]$HOSTNUM\:[0-9]\:[0-9]\:[0-9] | egrep '\[sd[a-z]{1,3}\].*logical' | awk '{print $4" "$5" "$6 }')
		
		SCSIADDR=$(echo $INFO | awk '{print $1}')
		KNAME=$(echo $INFO | awk '{print $2}' | sed 's/\]//' | sed 's/\[//')
		CAPACITY=$(echo $INFO | awk '{print $3}')
		echo -n -e "\e[4m\e[36m ata$ATANUM \e[0m"
		if [ -z $KNAME ]; then
			echo -e "\e[31mnot connected\e[0m"
		else
			echo -n SCSI:$SCSIADDR" "
			DISKINFO=$(lsblk -o NAME,SERIAL,MODEL,REV | grep $KNAME | head -n1)
			echo "$DISKINFO $(($CAPACITY*512/1048576/1024))G "
		fi
	}	
done

