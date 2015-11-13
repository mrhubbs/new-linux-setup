#!/bin/sh

# all packages to install
PKGS="git
	inkscape
	libreoffice
	spotify-client
	python-kivy
	python-kivy-examples"

# repositories to add

# spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
# kivy
sudo add-apt-repository ppa:kivy-team/kivy

# update...
sudo apt-get update

# install
sudo apt-get install -y ${PKGS}
