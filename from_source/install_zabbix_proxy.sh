#!/bin/bash

ZABBIX_VERSION=2.1.8
ZABBIX_SERVER={YOUR ZABBIX SERVER IP ADDR}
DB_HOST={YOUR DB HOSTNAME OR IP ADDR FOR ZABBIX PROXY}
DB_NAME=zabbix
DB_USER=zabbix
DB_PASS=zabbix

sudo aptitude install libopenipmi-dev libssh2-1-dev fping libcurl4-openssl-dev libiksemel-dev libiksemel-utils libsnmp-dev
sudo aptitude install libmariadbclient-dev

sudo groupadd zabbix
sudo useradd -g zabbix zabbix

sudo mkdir /var/log/zabbix
sudo chown zabbix:zabbix /var/log/zabbix

tar zxf zabbix-${ZABBIX_VERSION}.tar.gz
cd zabbix-${ZABBIX_VERSION}/
sudo ./configure --enable-server --enable-proxy --with-mysql --with-libcurl --with-net-snmp --with-libxml2 --with-openipmi --with-ssh2
sudo make && make install

cp -p misc/init.d/debian/zabbix-server /etc/init.d/
chmod +x /etc/init.d/zabbix-server
mv /etc/init.d/zabbix-server /etc/init.d/zabbix-proxy
sed -i 's/server/proxy/g' /etc/init.d/zabbix-proxy

mkdir /usr/local/etc/zabbix/

cat <<EOF > /usr/local/etc/zabbix/zabbix_proxy.conf
Server=${ZABBIX_SERVER}
Hostname=$(hostname)
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=5
DBHost=${DB_HOST}
DBName=${DB_NAME}
DBUser=${DB_USER}
DBPassword=${DB_PASS}
ConfigFrequency=300
StartVMwareCollectors=10
EOF
