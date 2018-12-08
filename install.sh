#!/bin/bash


# Username
user=$(whoami)


# Colors
if which tput >/dev/null 2>&1; then
	ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
	GREEN="$(tput setaf 2)"
	YELLOW="$(tput setaf 3)"
	BLUE="$(tput setaf 4)"
	BOLD="$(tput bold)"
	WHITE="$(tput sgr0)"
else
	GREEN=""
	YELLOW=""
	BLUE=""
	BOLD=""
	WHITE=""
fi


# Check system type
if [ "$(uname --kernel-version | grep -oh Microsoft)" = "Microsoft" ]; then
	# Windows subsystem
	windows=true
	echo "${BLUE}==>${WHITE}${BOLD} Running on ${YELLOW}Windows${WHITE}${BOLD}."
else
	# Plain Linux
	echo "${BLUE}==>${WHITE}${BOLD} Running on plain ${YELLOW}Linux${WHITE}${BOLD}."
fi


# Check for previous installations
installed=$(cat ~/.installed)
if [ "$installed" == "true" ]; then
	echo "${BLUE}==>${WHITE}${BOLD} Already installed, updating now."
fi


# Copy dotfiles into home directory
echo "${GREEN}==>${WHITE}${BOLD} Linking dotfiles to ${YELLOW}$HOME${WHITE}${BOLD}."
for entry in *; do
	if [[
		"$entry" != *".sh"* &&
		"$entry" != *"noinstall"* &&
		"$entry" != *"README"*
	]]
	then

		ln -sf $PWD/"$entry" ~/."$entry"
		echo "$entry is linked to ~/.$entry".
	fi
done

echo "${GREEN}==>${WHITE}${BOLD} Installing CLI packages."

sudo apt-get update -y
sudo apt-get upgrade -y


# Start to install packages
if [ "$installed" != "true" ]; then
	# Install git
	sudo apt install git -y

	# Install Docker
	if [-z $windows]; then
		sudo apt install docker.io docker-compose -y
	fi


	# Install node & npm/yarn
	if [-z $windows]; then
		sudo apt install nodejs npm -y
		sudo npm install yarn -g
	fi


	# Install dotnet
	if [-z $windows]; then
		wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb

        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb

        sudo add-apt-repository universe

        sudo apt install apt-transport-https
        sudo apt update

        sudo apt install dotnet-sdk-2.2 -y
	fi


	# Install ZSH & oh my zsh
	sudo apt install zsh -y
	if [ "$installed" != "true" ]; then
		# Install Oh my zsh
		echo "${GREEN}==>${WHITE}${BOLD} Installing Oh My ZSH."

		sh -c "$PWD/oh-my-zsh-install.sh"
		rm ~/.zshrc
		ln -sf ~/.zshrc.pre-oh-my-zsh ~/.zshrc
	fi


	# Install Python, powerline and pygments
	sudo apt install python -y
	sudo apt install python-pip -y

	pip install powerline-shell
	pip install powerline-status
	pip install pygments


	# Install utils
	sudo apt install zsh -y
	sudo apt install screenfetch -y
fi
