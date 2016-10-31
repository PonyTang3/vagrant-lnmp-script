#!/usr/bin/env bash

source ./util.sh
# source ./ppa.sh
sudo apt-get update

print_green "Install the basic tools"
# install the basic tools
sudo apt-get install -y build-essential gcc make
sudo apt-get install -y software-properties-common
sudo apt-get install -y curl wget vim git

# use vim as git default editor, replace nano
git config --global core.editor "vim"
