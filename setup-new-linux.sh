#!/bin/sh

# PLEASE NOTE: this script targets Xubuntu 64 bit.

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
# all packages to install
# ~ - ~ - ~ - ~ - ~ - ~ -

PKGS="git
	inkscape
	libreoffice
	spotify-client
	python-pip
	python3-pip
	python-kivy
	python-kivy-examples
	xubuntu-restricted-extras"

# ~ - ~ - ~ - ~ - ~ - ~ -
# repos to add
# ~ - ~ - ~ - ~ - ~ - ~ -

# spority
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
# TODO: avoid writing this multiple times
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# kivy
# TODO: how to avoid adding twice?
sudo add-apt-repository ppa:kivy-team/kivy

# update...
sudo apt-get update

# install
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
wget -q https://github.com/atom/atom/releases/latest -O /tmp/latest
ATOM_LATEST_DOWNLOAD_URL=$(awk -F '[<>]' '/href=".*atom-amd64.deb/ {match($0,"href=\"(.*.deb)\"",a); print "https://github.com/" a[1]} ' /tmp/latest)
wget -q "$ATOM_LATEST_DOWNLOAD_URL" -O /tmp/atom-amd64.deb
sudo dpkg -i /tmp/atom-amd64.deb

# set up for Python
apm install linter
sudo pip install flake8
sudo pip install flake8-docstrings
apm install linter-flake8

# other atom setup
apm install minimap
