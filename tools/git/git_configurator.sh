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

# --------------------------------------------------------------------------------------------------------------

# A bit about pacman tags we used
# --needed : Install packages only if needed
# --noconfirm : Do not ask for confirmation if there are any packages to be installed


# Installing git if its not installed
tput setaf 4
echo "##################### Installing git ###########################"
echo 
sudo pacman -S git --needed --noconfirm
tput sgr0

# Setting mail and name to be associated with local git
tput setaf 3
echo "############## Setting up name and email ###################"
echo 
tput sgr0
read -p "Enter your name: " name
read -p "Enter your email address: " mail
git config --global user.name $name
git config --global user.email $mail
tput setaf 2
echo 
echo "##### Name and Email set successfully ####"
echo 
tput sgr0

# Setting defult text editor
sudo git config --system core.editor "nano -w"

# git-credential-cache - Helper to temporarily store passwords in memory
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=32000'

# Choosing whether to push all or just current branch to the remote repo.
git config --global push.default simple


# Setting ssh key
tput setaf 3
echo "###################### Setting up SSH key ######################"
echo 
tput sgr0
read -p "Do you want to generate new SSH key pair?[Y/n]: " choice
if [ "$choice" == "Y" ] || [ "$choice" == "y" ] || [ "$choice" == "" ]
then
	# Installing open-ssh if needed
	tput setaf 4
	echo "##################### Installing SSH ###########################"
	echo ""
	sudo pacman -S openssh --needed --noconfirm
	tput sgr0
	
	read -p "Enter the mail to be used to set up SSH key(Empty to use the same mail id you entered for git): " ssh_mail
	if [ "$ssh_mail"=="" ]
	then
		ssh-keygen -t ed25519 -C $mail
	else
		ssh-keygen -t ed25519 -C $ssh_mail
	fi

	# Starting the SSH-agent in background
	eval "$(ssh-agent -s)"

	tput setaf 2
	echo 
	echo "##### SSH key pair generated successfully ####"
	echo 
	tput sgr0

	tput setaf 1
	echo
	echo "visit:"
	echo "1.To add your SSH key to your github account"
	echo "		https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account"
	echo 
	echo "2.To add your SSH key to your gitlab account"
	echo "		https://docs.gitlab.com/ee/ssh/#add-an-ssh-key-to-your-gitlab-account"
	tput sgr0
fi


# Setting GPG key
tput setaf 3
echo "###################### Setting up GPG key ######################"
echo 
tput sgr0
read -p "Do you want to generate new GPG key pair?[Y/n]: " choice
if [ "$choice" == "Y" ] || [ "$choice" == "y" ] || [ "$choice" == "" ]
then
	# Installing gpgme if needed
	tput setaf 4
	echo "##################### Installing GPG ###########################"
	echo 
	sudo pacman -S gpgme --needed --noconfirm
	tput sgr0

	gpg --full-generate-key

	tput setaf 2
	echo 
	echo "##### GPG key pair generated successfully ####"
	echo 
	tput sgr0
	tput setaf 1
	echo
	echo "visit:" 
	echo "1.To add your GPG key to your github account"
	echo "		https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account"
	echo 
	echo "2.To add your GPG key to your gitlab account"
	echo "		https://docs.gitlab.com/ee/user/project/repository/gpg_signed_commits/#adding-a-gpg-key-to-your-account"
	tput sgr0
fi

tput setaf 2
echo "################################################################"
echo "###################    T H E   E N D      ######################"
echo "################################################################"
tput sgr0
