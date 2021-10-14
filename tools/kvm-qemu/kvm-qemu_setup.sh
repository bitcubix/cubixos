#!/bin/bash
set -e
##################################################################################################################
# Author	:	Raj Pansuriya
# Contact   :   rajpansuriya40@gmail.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.

##################################################################################################################

# Checking virtualization settings
tput setaf 3
echo
echo "###### Checking virtulization settings of your machine ######"
echo
tput sgr0
virtualization=$(egrep -o '(vmx|svm)' /proc/cpuinfo | sort | uniq)
if [ "$virtualization" == "" ]
then
    tput setaf 1
    echo    
    echo "Virtualization is disbaled.
Please check your BIOS settings and enable it."
    tput sgr0
    exit
else
    tput setaf 2
    echo "Virtualization is enabled. proceeding with the script!"
    echo
    tput sgr0
fi

# Installing kvm,qemu,virt-manager and other necessary packages
tput setaf 4
echo "########### Installing qemu,virt-manager and necessary packages ############"
echo
# iptables and iptables-nft are the smae package with a minor difference.
# iptables is a kernel packet control tool which uses leagacy interface
# iptables-nft is a kernel packet control tool which uses nft interface

# iptables-nft is enabled by-default,
# you can disable it it if you have legacy hardware

# sudo pacman -Rdd iptables-nft
# sudo pacman -S --noconfirm --needed iptables

sudo pacman -Rdd iptables --noconfirm
sudo pacman -S --noconfirm --needed iptables-nft

sudo pacman -S --noconfirm --needed qemu libvirt bridge-utils virt-viewer spice-vdagent virt-manager xf86-video-qxl vde2 dnsmasq dmidecode

sudo pacman -S --noconfirm --needed  ebtables 
tput sgr0
tput setaf 2
echo
echo "##### packages installed successfully ####"
echo
tput sgr0

tput setaf 3
echo "###################### Enabling systemd services ######################"
echo
tput sgr0
sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service
tput setaf 2
echo
echo "##### Service is enabled ####"
echo
tput sgr0

# Settings for nested virtualization
# Variable to store supported virtualization by user's machine
if [ "virtualization" == "vmx" ]
then
    echo -e "options kvm-intel nested=1" | sudo tee -a /etc/modprobe.d/kvm-intel.conf
else
    echo -e "options kvm-amd nested=1" | sudo tee -a /etc/modprobe.d/kvm-amd.conf
fi

##Change your username here
tput setaf 3
echo "########## Adding your login account to libvert & kvm group ###########"
echo
tput sgr0
read -p "What is your login account?
It will be used to add this user to the 2 different groups : " choice
sudo gpasswd -a $choice libvirt
sudo gpasswd -a $choice kvm
tput setaf 2
echo
echo "##### login added to the necessary groups ####"
echo
tput sgr0


echo '
nvram = [
    "/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
]' | sudo tee --append /etc/libvirt/qemu.conf


# Bridge between host and guest system
sudo virsh net-define /etc/libvirt/qemu/networks/default.xml
sudo virsh net-autostart default

tput setaf 1
echo    
echo "##############################################################################"
echo "#####################           FIRST REBOOT             #####################"
echo "##############################################################################"
tput sgr0
