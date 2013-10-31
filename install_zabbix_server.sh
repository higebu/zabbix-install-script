#!/bin/bash

ZABBIX_VERSION=2.1.8

sudo aptitude -y install libopenipmi-dev libssh2-1-dev fping libcurl4-openssl-dev libiksemel-dev libiksemel-utils libsnmp-dev
sudo aptitude -y install libmariadbclient-dev
tar zxvf zabbix-${ZABBIX_VERSION}.tar.gz
cd zabbix-${ZABBIX_VERSION}/
sudo ./configure --enable-server --with-mysql --with-libcurl --with-net-snmp --with-libxml2 --with-openipmi --with-ssh2
sudo make && make install

cp -p misc/init.d/debian/zabbix-server /etc/init.d/
chmod +x /etc/init.d/zabbix-server
