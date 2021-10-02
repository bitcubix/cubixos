# Basic Arch Linux Install
This folder contains everthing you need for a basic Arch Linux installation.

## Scripts
If you want to keep it simple (you little sucker) you can use the script:

[create boot stick script](create_boot_stick.sh)

## Create Bootable Stick
> stick has path `/dev/sdc` in this tutorial

unmount the stick
```bash
sudo unmount /dev/sdc
```
flash the ISO from [archlinux.org](https://archlinux.org/download) with dd
```bash
sudo dd bs=4M if=~/downloads/archlinux.iso of=/dev/sdc oflag=sync status=progress
```
now boot from usb stick
## First Steps
### Keyboard Layout
set the right keyboard layout replace `de_CH-latin1` with your layout
```bash
loadkeys de_CH-latin1
```
### Internet Setup
check for internet connection  `ping`
for wifi connection use `iwctl`
### Time Setup
setup clock sync
```bash
timedatectl set-ntp true
```
## Partitioning
> drive has path `/dev/sda` in this tutorial

open drive with gdisk
```bash
gdisk /dev/sda
```
delete all partitions  using option `d`

create boot partition with option `n` with default number, default first sector and set last sector to `+512M` and set `ef00`as type

create root partition with option `n` with default number, with default first and last sector ans set `8300` as type

use option `w` to write the changes to the disk
## Root Partition Encryption
use `cryptsetup` to encrypt the root partition
```bash
cryptsetup -y -v luksFormat /dev/sda2
```
use `cryptsetup` to open the encrypted partition
```bash
cryptsetup open /dev/sda2 cryptroot
```
## Create File Systems
create the boot file system
```bash
mkfs.fat -F32 /dev/sda1
```
create the root file system
```bash
mkfs.ext4 /dev/mapper/cryptroot
```
## Mount File Systems
mount the root file system
```bash
mount /dev/mapper/cryptroot /mnt
```
create the boot directory
```bash
mkdir /mnt/boot
```
mount the boot file system
```bash
mount /dev/sda1 /mnt/boot
```
## Create Swap File
create swap file with `dd` set `count` to 1.5 times of RAM size
```bash
dd if=/dev/zero of=/mnt/swapfile bs=1M count=24576 status=progress
```
set the right permissions
```bash
chmod 600 /mnt/swapfile
```
make the file to a swapfile
```bash
mkswap /mnt/swapfile
```
activate swapfile
```bash
swapon /mnt/swapfile
```
## Install the actual OS
use `pacstrap` to install needed packages
```bash
pacstrap /mnt base base-devel linux linux-firmware linux-headers nano
```
## Create File System Table
generate file system table with UUIDs
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```
## Entering the chroot
```bash
arch-chroot /mnt
```
## Set Locales
set your time zone change `/usr/share/zoneinfo/Europe/Zurich` to your zone
```bash
ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
```
set the system clock
```bash
hwclock --systohc
```
choose your locals for example `en_US.UTF-8` by uncomment it
```bash
nano /etc/locale.gen
```
now generate the locales
```bash
locale-gen
```
set the local var
```bash
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
```
## Set Hostname
> the system hostname is `arch` in this tutorial

set the hostname by replacing `arch` with your hostname
```bash
echo 'arch' > /etc/hostname
```
insert following to `/etc/hosts`
```txt
127.0.0.1     localhost
::1           localhost
127.0.1.1     arch.localdomain        arch
```
## Set Password
set the password for the root user
```bash
passwd
```
## Initramfs configuration
use `nano` to edit `/etc/mkinitcpio.conf` and in the `HOOKS` array add `keyboard` between `autodetect` and `modconf` and add `encrypt` between `block` and `filesystems` 

then create the config
```bash
mkinitcpio -P
```
## Install Grub
install all required packages replace `intel-ucode` with `amd-ucode` if you use a amd cpu
```bash
pacman -S grub efibootmgr intel-ucode
```
get the UUID of your root partition using `blkid`
```bash
blkid -s UUID -o value /dev/sda2
```
use `nano` to edit `/etc/default/grub` and set `GRUB_CMDLINE_LINUX` to `cryptdevice=UUID=<uuid>:cryptroot` while replacing `<uuid>` with the uuid from the previous step

then install the grub bootloader to the system
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```
as last generate the grub config
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```
## Install Network Manager
install the right package
```bash
pacman -S networkmanager
```
enable the network manager
```bash
systemctl enable NetworkManager
```

## Finish
your basic Arch Linux install is finished you can now reboot your system
```bash
exit
reboot
``` 
## Add User (Optional)
after restarting your system you can add a user

first edit the sudosers file with `EDITOR=nano visudo` and uncomment `%wheel ALL=(ALL) NOPASSWD: ALL`

then add the user replace `bitcubix` with your username
```bash
useradd --create-home --groups wheel,video bitcubix
```
then you can set a password for your user again replace `bitcubix` with your username
```bash
passwd bitcubix
```
to login run `exit` then you can login with your new user
