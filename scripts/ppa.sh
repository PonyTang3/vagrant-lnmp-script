#!/usr/bin/env bash

source ./util.sh
print_green "Adding ppa"

echo "Use Nginx 1.8"
sudo add-apt-repository -y  ppa:nginx/stable

echo "Use PHP 5.6"
sudo add-apt-repository -y  ppa:ondrej/php5-5.6

echo "Use Redis 3.x"
sudo add-apt-repository -y ppa:chris-lea/redis-server

print_green "ppa added, need to run apt-get update"
