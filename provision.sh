#!/usr/bin/env bash

echo "///////////////////////////////////////////////"
echo "Updating canonical repositories..."
echo "///////////////////////////////////////////////"
apt-get update > /dev/null

echo "///////////////////////////////////////////////"
echo "Installing php..."
echo "///////////////////////////////////////////////"
apt-get install --assume-yes php5-cli
apt-get install --assume-yes php5-mcrypt php5-intl php5-mysql php5-curl

echo "///////////////////////////////////////////////"
echo "Setting php-cli date.timezone to Madrid..."
echo "///////////////////////////////////////////////"
sudo sed -i "s/^;date.timezone =$/date.timezone = \"Europe\/Madrid\"/" /etc/php5/cli/php.ini |grep "^timezone" /etc/php5/cli/php.ini

echo "///////////////////////////////////////////////"
echo "Installing Mysql..."
echo "///////////////////////////////////////////////"
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install mysql-server

echo "///////////////////////////////////////////////"
echo "Installing curl..."
echo "///////////////////////////////////////////////"
apt-get install --assume-yes curl

echo "///////////////////////////////////////////////"
echo "Installing composer..."
echo "///////////////////////////////////////////////"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "///////////////////////////////////////////////"
echo "Installing Redis..."
echo "///////////////////////////////////////////////"
apt-get install build-essential
apt-get install tcl8.5
wget http://download.redis.io/releases/redis-3.0.5.tar.gz
tar xzf redis-3.0.5.tar.gz
cd redis-3.0.5
make
make install
cd utils
./install_server.sh

echo "///////////////////////////////////////////////"
echo "Deploying project..."
echo "///////////////////////////////////////////////"
cd /vagrant
composer install
php app/console doctrine:database:create
php app/console doctrine:schema:update --force

