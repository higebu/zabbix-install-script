#!/bin/bash

ZABBIX_VERSION=2.1.8
DB_HOST={YOUR DB HOSTNAME OR IP ADDR}
DB_USER={YOUR DB USER}
DB_PASS={YOUR DB PASSWORD}
PROXY_HOST={YOUR ZABBIX PROXY HOSTNAME OR IP ADDR}

CMD="mysql -u$DB_USER -p$DB_PASS -h$DB_HOST"
$CMD -e "create database zabbix character set utf8;"
echo "create database $?"
$CMD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'${PROXY_HOST}' IDENTIFIED BY '${PASS}' WITH GRANT OPTION;"
echo "grant 1 $?"
$CMD -e "grant all privileges on zabbix.* to zabbix@'${PROXY_HOST}' identified by 'zabbix';"
echo "grant 2 $?"

cd zabbix-${ZABBIX_VERSION}/database/mysql/
$CMD zabbix < schema.sql
