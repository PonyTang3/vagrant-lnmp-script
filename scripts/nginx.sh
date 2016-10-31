#!/usr/bin/env bash

source ./util.sh

# http://nginx.org/en/linux_packages.html#stable
print_green "Installing the latest stable Nginx"

# already in in ppa.sh
#sudo add-apt-repository -y  ppa:nginx/stable
#sudo apt-get update
sudo apt-get install -y nginx

echo "Copy nginx config file"
sudo cp vagrant.lk.conf /etc/nginx/conf.d/

print_green "Nginx installed"
