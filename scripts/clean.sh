#!/usr/bin/env bash

source ./util.sh

print_green 'Clean apt'

sudo apt-get -y autoremove
sudo apt-get -y clean

print_green 'Cleanup bash history'

sudo unset /root/.bash_history
sudo unset /home/vagrant/.bash_history
sudo rm /root/.bash_history
sudo rm /home/vagrant/.bash_history

print_green 'Bash history for root and vagrant are removed'

# TODO: clean up apt-cache, log file
