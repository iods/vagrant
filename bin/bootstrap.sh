#!/usr/bin/env bash

# Version 0.1.0 [2017-03-13]
#
#   Project     : Darkstar Vagrant Boilerplate
#   Markup      : bootstrap.sh
#   Author      : Rye Miller
#   Version     : v0.1.0 (beta)
#   License     : MIT
#   License URI : http://github.com/iods/vagrant/LICENSE
#
# Website:   http://github.com/iods/vagrant/bootstrap.sh (public)
# Copyright: (c) 2017 Rye Miller, DRKSTR

# Set box variables
PROJECT_DB_NAME='testdb'
PROJECT_DB_USERNAME='test'
PROJECT_DB_PASSWORD='test'

# Update/Upgrade the Repository
sudo apt-get update
sudo apt-get -y upgrade

# Install Apache
sudo apt-get -y install apache2

# Install MySQL and dependencies, including root/root (not user defined above) credentials
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root"
sudo apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql

# Add the vagrant and www-data users
sudo usermod -a -G vagrant www-data

# Install a MySQL database
if [ ! -f /var/log/databasesetup ];
then
    echo "CREATE USER '${PROJECT_DB_USERNAME}'@'localhost' IDENTIFIED BY '${PROJECT_DB_PASSWORD}'" | mysql -uroot -proot
    echo "CREATE DATABASE ${PROJECT_DB_NAME}" | mysql -uroot -proot
    echo "GRANT ALL ON ${PROJECT_DB_NAME}.* TO '${PROJECT_DB_USERNAME}'@'localhost'" | mysql -uroot -proot
    echo "flush privileges" | mysql -uroot -proot

    touch /var/log/databasesetup

    if [ -f /vagrant/data/import.sql ];
    then
        mysql -uroot -proot ${PROJECT_DB_NAME} < /vagrant/data/import.sql
    fi
fi

# Install PHP and dependencies
sudo apt-get -y install php5 libapache-mod-php5 curl php5-curl php5-gd php5-mcrypt

# Install Composer for PHP
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Setup VirtualHosts file
cat /var/config/apache2/default | tee /etc/apache2/sites-available/default

# Enable Rewrite (mod_rewrite)
sudo a2enmod rewrite

# Restart Apache
sudo service apache2 restart