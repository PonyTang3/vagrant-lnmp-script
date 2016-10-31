#!/usr/bin/env bash

source ./util.sh

print_green "Installing MySQL"

print_green "Set default mysql root password as vagrant"

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
sudo apt-get install -y mysql-server mysql-client

sudo sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo echo "skip-name-resolve" >> /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="vagrant" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "GRANT ALL ON *.* TO 'homestead'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="vagrant" -e "FLUSH PRIVILEGES;"

mysql --user="root" --password="vagrant" -e "CREATE DATABASE IF NOT EXISTS homestead DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";

print_green "MySQL installed"
