#!/usr/bin/env bash

source ./util.sh

print_green "Installing redis"

# already in in ppa.sh
#sudo add-apt-repository -y ppa:chris-lea/redis-server
#sudo apt-get update
sudo apt-get install -y redis-server
redis-server -v

print_green "Redis installed"
