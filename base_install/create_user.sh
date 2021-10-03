#!/bin/bash

if [ "$EUID" -ne 0 ]
    then echo "please run as root"
    exit
fi

# edit sudoers file
sed '/# %wheel ALL=(ALL) NOPASSWD: ALL/s/^# //' -i /etc/sudoers

# create new user
read -p "enter a new username: " username
useradd --create-home --groups wheel,video ${username}
passwd ${username}

echo "new user is created"