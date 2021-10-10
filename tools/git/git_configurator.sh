#!/bin/bash  
#
##################################################################################################################
# Written to be used on 64 bits computers
# Author 	: 	Raj Pansuriya
# E-mail 	: 	rajpansuriya40@gmail.com
##################################################################################################################
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

# Problem solving commands (Can be included if needed)

# Read before using it.
# https://www.atlassian.com/git/tutorials/undoing-changes/git-reset
# git reset --hard orgin/master
# ONLY if you are very sure and no coworkers are on your github.

# Command that have helped in the past
# Force git to overwrite local files on pull - no merge
# git fetch all
# git push --set-upstream origin master
# git reset --hard orgin/master




# Installing git if its not installed
tput setaf 4
echo "##################### Installing git ###########################"
echo ""
sudo pacman -S git --needed
tput sgr0

# Setting mail and name to be associated with local git
tput setaf 3
echo "############## Setting up name and email ###################"
echo ""
tput sgr0
read -p "Enter your name: " name
read -p "Enter your email address: " mail
git config --global user.name $name
git config --global user.email $mail
tput setaf 2
echo ""
echo "##### Name and Email set successfully ####"
echo ""
tput sgr0

# Setting defult text editor
sudo git config --system core.editor "nano -w"

# git-credential-cache - Helper to temporarily store passwords in memory
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=32000'

# Choosing whether to push all or just current branch to the remote repo.
git config --global push.default simple


tput setaf 2
echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
tput sgr0