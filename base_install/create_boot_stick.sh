#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "please run as root"
    exit
fi

mirror="https://theswissbay.ch"

# show list of all atached devices
lsblk

# safe the selected device
read -p 'select drive to create boot stick (/dev/sda): ' usb_drive

# unmount the selected device
umount $usb_drive

# define iso and hash file location
iso_file="/tmp/archlinux.iso"
md5_hash="/tmp/archlinux_md5sums.txt"

# check if iso file already is available in /tmp folder
if ! [ -f "$iso_file" ]; then
    # if iso not in tmp folder download it
    wget $mirror/archlinux/iso/2021.10.01/archlinux-2021.10.01-x86_64.iso -O $iso_file
fi
# download the hash file
wget $mirror/archlinux/iso/2021.10.01/md5sums.txt -O $md5_hash

# get hash sum from iso file
SUM1=$(md5sum $iso_file | head -n1 | sed -e 's/\s.*$//')

# get hash sum from hash file
SUM2=$(cat $md5_hash | head -n1 | sed -e 's/\s.*$//')

# check if hash from iso and hash file are correct
if [ "$SUM1" = "$SUM2" ]; then
    echo "download is verified"
else
    echo "invalid file downloaded"
    exit 1
fi

# flash iso to usb drive using dd
dd bs=4M if=$iso_file of=$usb_drive oflag=sync status=progress

echo "your arch linux boot stick is ready"
