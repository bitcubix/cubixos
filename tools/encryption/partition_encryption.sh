#!/bin/bash

# set colors
purple=`echo -en "\e[35m"`
normal=`echo -en "\e[0m"`
green=`echo -en "\e[32m"`
orange=`echo -en "\e[33m"`

# echo title
echo -e "${purple}#################\nEncryption Script\n#################$normal"

# output blocks
lsblk -f

# read partition from input
read -p "${green}Enter partition [/dev/sda1]: $normal" input
partition=${input:-/dev/sda1}
echo "partition: "$partition

# read label from input
read -p "${green}Enter label [backup]: $normal" input
label=${input:-backup}
echo "label: "$label

# wait for user input
read -p "${orange}Press enter to start: $normal"

# unmount the select partition
sudo umount $partition

# override partition with dd / urandom
sudo dd bs=1G status=progress if=/dev/urandom of=$partition

# encrypt the partition
sudo cryptsetup luksFormat $partition

# open encrypted device to device mapper
sudo cryptsetup luksOpen $partition $label

# create filesystem for the partition
sudo mkfs.ext4 -L $label /dev/mapper/$label

# mount the devicemapper to /mnt
sudo mount /dev/mapper/$label /mnt

# set permissions to /mnt
sudo chown 1000:1000 /mnt

# unmount devicemapper
sudo umount /dev/mapper/$label

echo "${green}Done...$normal"
