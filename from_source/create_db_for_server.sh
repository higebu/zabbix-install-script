#!/bin/bash

ZABBIX_VERSION=2.1.8
DB_HOST={YOUR DB HOST NAME OR IP ADDR}
DB_USER={YOUR DB USER}
DB_PASS={YOUR DB PASSWORD}
ZABBIX_HOST={YOUR ZABBIX SERVER HOSTNAME OR IP ADDR}

CMD="mysql -u$DB_USER -p$DB_PASS -h$DB_HOST"
$CMD -e "create database zabbix character set utf8;"
echo "create database $?"
$CMD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'${ZABBIX_HOST}' IDENTIFIED BY '${PASS}' WITH GRANT OPTION;"
echo "grant 1 $?"
$CMD -e "flush privileges;"
$CMD -e "grant all privileges on zabbix.* to zabbix@'${ZABBIX_HOST}' identified by 'zabbix';"
echo "grant 2 $?"
$CMD -e "flush privileges;"

cd zabbix-${ZABBIX_VERSION}/database/mysql/
$CMD zabbix < schema.sql
$CMD zabbix < images.sql
$CMD zabbix < data.sql
