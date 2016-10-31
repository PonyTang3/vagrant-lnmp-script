#!/usr/bin/env bash

source ./util.sh

# Composer
print_green "Installing composer"
sudo curl -sS https://getcomposer.org/installer | php
chmod +x composer.phar
sudo mv composer.phar /usr/local/bin/composer
# 设置中国镜像
composer config -g repo.packagist composer https://packagist.phpcomposer.com
# TODO: add composer global require bin path to path
print_green "Composer installed"

sudo service memcached restart

sudo systemctl restart nginx

sudo systemctl restart php7.0-fpm

sudo systemctl restart mysql
