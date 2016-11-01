#!/usr/bin/env bash

source ./util.sh

print_green "Installing PHP"

# already in in ppa.sh
#echo "Adding ppa to use 5.6"
#sudo add-apt-repository -y  ppa:ondrej/php5-5.6
#sudo apt-get -y update

echo "Install php and extensions"
sudo apt-get install -y php7.0-common php7.0-cli php7.0-fpm php7.0-mysql \
php7.0-sqlite php7.0-curl php7.0-gd php7.0-gmp php7.0-mcrypt \
php-redis php-imagick php7.0-intl php7.0-json php-memcached

# PHP Error Reporting Config
echo "enable all the error report for develop"
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini

# Fix permissions for session dir
sudo chmod -R 777 /var/lib/php/sessions
sudo echo "opcache.revalidate_freq=0" >> /etc/php/7.0/fpm/conf.d/10-opcache.ini
sudo echo "opcache.fast_shutdown=1" >> /etc/php/7.0/fpm/conf.d/10-opcache.ini

php -v

print_green "PHP installed"
