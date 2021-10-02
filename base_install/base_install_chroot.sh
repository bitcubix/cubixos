#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "please run as root"
    exit
fi

# set timezone
read -p 'enter your time zone (Europe/Zurich): ' timezone
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime 1> /dev/null

# set system clock
echo "set system clock"
hwclock --systohc

# generate locales
echo "generate locales"
sed '/#en_US.UTF-8 UTF-8/s/^#//' -i /etc/locale.gen
locale-gen 1> /dev/null
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# set default keymap
read -p 'enter your default keymap (de_CH-latin1): ' keymap
echo "KEYMAP=$keymap" > /etc/vconsole.conf

# set hostname
read -p 'enter a new hostname: ' hostname
echo "$hostname" > /etc/hostname
echo "127.0.0.1     localhost
::1           localhost
127.0.1.1     $hostname.localdomain        $hostname" > /etc/hosts

# set new password for root user
echo "enter password for root user"
passwd

# create initramfs config
echo "create initramfs config"
sed 's/^HOOKS=(.*/HOOKS=(base udev autodetect keyboard consolefont keymap modconf block encrypt filesystems keyboard fsck)/' -i /etc/mkinitcpio.conf
mkinitcpio -P 1> /dev/null

# install grub
PS3="choose your cpu: "
select cpu in amd intel
do
    ucode=$cpu"-ucode"
    break
done
echo "install grub boot manager"
pacman -S grub efibootmgr ${ucode} 1> /dev/null

# create grub config
echo "create grub config"
root_uuid=$(blkid -s UUID -o value /dev/sda2)
sed 's/^GRUB_CMDLINE_LINUX=".*/GRUB_CMDLINE_LINUX="cryptdevice=UUID='$root_uuid':cryptroot"/' -i /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 1> /dev/null
grub-mkconfig -o /boot/grub/grub.cfg 1> /dev/null

# install networkmanager
echo "install networkmanager and iwd"
pacman -S networkmanager iwd
systemctl enable NetworkManager

echo "installation finished now you can restart your pc"
