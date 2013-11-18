#!/bin/bash

ZABBIX_VERSION=2.1.8

sudo aptitude install nginx php5 php5-fpm php5-gd php5-mysql ttf-dejavu-core
# TODO: Configure Nginx
# TODO: Configure PHP and PHP FPM
tar zxf zabbix-${ZABBIX_VERSION}.tar.gz
cd zabbix-${ZABBIX_VERSION}/frontends
sudo cp -r php /usr/share/nginx/html/zabbix
sudo chown -R www-data:www-data /usr/share/nginx/html/zabbix
sudo service php5-fpm start
sudo service nginx restart
