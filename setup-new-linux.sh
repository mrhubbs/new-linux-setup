#!/bin/bash

# PLEASE NOTE: this script targets Xubuntu 64 bit.

LOG_PREFIX="|>--<["

# ~ - ~ - ~ - ~ - ~ - ~ -
# process arguments
# ~ - ~ - ~ - ~ - ~ - ~ -

if [ -z ${1+x} ]; then
	echo "Argument 1 must be git user name.";
	exit 1;
else
	echo "git user name = $1";
fi

if [ -z ${2+x} ]; then
	echo "Argument 2 must be git user email.";
	exit 1;
else
	echo "git user email = $2";
fi

# ~ - ~ - ~ - ~ - ~ - ~ -
# functions
# ~ - ~ - ~ - ~ - ~ - ~ -
function ppa_exists() {
	grep ^ /etc/apt/sources.list.d/* | grep "$1" > /dev/null
	grep_res=$?
	return $([ $grep_res -eq 1 ])
}

# ~ - ~ - ~ - ~ - ~ - ~ -
# all packages to install
# ~ - ~ - ~ - ~ - ~ - ~ -

PKGS="git
	gedit
	inkscape
	libreoffice
	spotify-client
	xubuntu-restricted-extras
	usb-creator-gtk
	brasero
	python-pip
	python3-pip
	python-kivy
	python-kivy-examples
	python-sphinx"

# ~ - ~ - ~ - ~ - ~ - ~ -
# repos to add
# ~ - ~ - ~ - ~ - ~ - ~ -

echo "$LOG_PREFIX checking PPAs..."

# spotify
ppa_exists spotify
if [ $? -ne 1 ] ; then
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
	echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
else
	echo "$LOG_PREFIX already added Spotify PPA..."
fi

# kivy
ppa_exists kivy
if [ $? -ne 1 ] ; then
	sudo add-apt-repository ppa:kivy-team/kivy
else
	echo "$LOG_PREFIX already added Kivy PPA..."
fi

# update...
echo "$LOG_PREFIX updating packages..."
sudo apt-get update

# install
echo "$LOG_PREFIX installing packages..."
sudo apt-get install -y ${PKGS}

# ~ - ~ - ~ - ~ - ~ - ~ -
# configure git
# ~ - ~ - ~ - ~ - ~ - ~ -

git config --global push.default simple  # this can be removed in the future
git config --global user.name $1
git config --global user.email $2
git config --global alias.unstage 'reset --'
git config --global alias.serve "daemon --verbose --export-all --base-path=.git --reuseaddr --strict-paths .git/"

# ~ - ~ - ~ - ~ - ~ - ~ -
# atom
# ~ - ~ - ~ - ~ - ~ - ~ -

# install
# (courtesy of http://askubuntu.com/questions/589469/how-to-automatically-update-atom-editor)
echo "$LOG_PREFIX downloading latest stable Atom..."
wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
ATOM_LATEST_DOWNLOAD_URL=$(awk -F '[<>]' '/href=".*atom-amd64.deb/ {match($0,"href=\"(.*.deb)\"",a); print "https://github.com/" a[1]} ' /tmp/latest)
wget "$ATOM_LATEST_DOWNLOAD_URL" -O /tmp/atom-amd64.deb
echo "$LOG_PREFIX installing Atom..."
sudo dpkg -i /tmp/atom-amd64.deb

# set up for Python
apm install linter
sudo pip install flake8
sudo pip install flake8-docstrings
apm install linter-flake8

# other atom setup
apm install minimap
apm install project-manager
apm install color-picker
apm install language-arduino
apm install language-lua
apm install language-flatbuffers

echo "$LOG_PREFIX SETUP IS COMPLETE!!!"
