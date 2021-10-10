#!/bin/bash

# check root permissions
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

# read mirror country from input
echo "To include Worldwide servers, pass an empty string to the country flag. For example, to include France, Germany, and Worldwide mirrors, one should use --country 'France,Germany,'."
read -p 'enter your mirror countrys (Germany,Canada): ' country

# install yay from git repo (from source)
pacman -S --needed git base-devel reflector pacman-mirrorlist
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
su ${USER} -c "makepkg -si"

# write reflector config file
cat <<EOF > /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--country $country
--protocol https
--latest 5
EOF

# write pacman hook for updating mirror list
mkdir -p /etc/pacman.d/hooks/
cat <<EOF > /etc/pacman.d/hooks/mirrorupgrade.hook
[Trigger]
Operation = Upgrade
Type = Package
Target = pacman-mirrorlist

[Action]
Description = Updating pacman-mirrorlist with reflector
When = PostTransaction
Depends = reflector
Exec = /bin/sh -c 'systemctl start reflector.service; [ -f /etc/pacman.d/mirrorlist ]'
EOF

echo ""
echo "finish aur setup"
