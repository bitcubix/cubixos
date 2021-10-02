#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "please run as root"
    exit
fi

# check internet connection
if ping -q -w 1 -c 1 archlinux.org > /dev/null; then
    echo -e "internet connection is available\n"
else
    echo "no internet connection available"
    exit 1
fi

# activate ntp sync
timedatectl set-ntp true 1> /dev/null

# select device for partitioning
echo "device list from lsblk:"
PS3="choose device for boot and root partition: "
select dev in $(lsblk -d | tail -n+2 | awk '{print $1"_"$4}')
do
    base_device="/dev/"$(echo $dev | cut -d "_" -f 1)
    #echo you picked device $dev \($REPLY\)
    break
done

# check if selection is a valid block device
if [ -b $base_device ]; then
    echo "choosen device is $base_device"
else
    echo "invalid device selection"
    exit 1
fi

# create boot and root partition with fdisk
echo "create partitions"
fdisk ${base_device} <<EOF
g
n
1
 
+512M
t
1
n



w
q
EOF

# cryptsetup setup for root partition
echo "encrypt root partition"
cryptsetup -y -v luksFormat $base_device"2"

# open encrypted root partion to dev mapper
echo "open root partition"
cryptsetup open /dev/sda2 cryptroot $base_device"2"

# create filesystem entry for boot/root partition
echo "create filesystems"
mkfs.fat -F32 $base_device"1" 1> /dev/null
mkfs.ext4 /dev/mapper/cryptroot 1> /dev/null

# mount root and boot partition to the filesystem
echo "mounting root and boot partition"
mount /dev/mapper/cryptroot /mnt 1> /dev/null
mkdir /mnt/boot 1> /dev/null
mount ${base_device}1 /mnt/boot 1> /dev/null

# get archlinx basic packages with pacstrap
echo "get all base packages with pacstrap"
pacstrap /mnt base base-devel linux linux-firmware linux-headers nano 1> /dev/null

# create file system table with UUID's
echo "generate file system table"
genfstab -U /mnt >> /mnt/etc/fstab 1> /dev/null

# change to the arch chroot
echo "change to arch root"
cp base_install_chroot.sh /mnt/base_install_chroot.sh
chmod +x /mnt/base_install_chroot.sh
arch-chroot /mnt ./base_install_chroot.sh
