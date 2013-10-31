#!/bin/bash

ZABBIX_VERSION=2.1.8
ZABBIX_SERVER={YOUR ZABBIX SERVER IP ADDR}

tar zxvf zabbix-${ZABBIX_VERSION}.tar.gz
cd zabbix-${ZABBIX_VERSION}/
sudo ./configure --enable-agent
sudo make && make install

cp -p misc/init.d/debian/zabbix-agent /etc/init.d/
chmod +x /etc/init.d/zabbix-agent

cat <<EOF > /usr/local/etc/zabbix_agentd.conf
LogFile=/var/log/zabbix_agentd.log
EnableRemoteCommands=0
Server=${ZABBIX_SERVER}
ServerActive=${ZABBIX_SERVER}
Hostname=$(hostname)
AllowRoot=1
Include=/usr/local/etc/zabbix_agentd.conf.d/
EOF
