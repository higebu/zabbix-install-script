#!/bin/bash

# This script should be run after installing DB.

ZABBIX_SERVER_IP=$(ifconfig eth0 | grep 'inet addr' | awk '{print $2}' | awk -F':' '{print $2}')
ZABBIX_SERVER_NAME=$(hostname)
DB_HOST={YOUR_DB_HOST}

cat <<EOF >> /etc/sysctl.conf
net.ipv4.neigh.default.gc_thresh1 = 512
net.ipv4.neigh.default.gc_thresh2 = 2048
net.ipv4.neigh.default.gc_thresh3 = 4096
fs.file-max = 65536
kernel.shmmax = 2147483648
kernel.shmall = 524288
EOF
sysctl -p

ulimit -n 65536
cat <<EOF >> /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
EOF

wget http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+precise_all.deb
dpkg -i zabbix-release_2.2-1+precise_all.deb
aptitude -y update
DEBIAN_FRONTEND=noninteractive aptitude -y install zabbix-agent zabbix-frontend-php zabbix-get zabbix-java-gateway zabbix-sender zabbix-server-mysql
service mysql stop
update-rc.d -f mysql remove

mysql -uroot -h ${DB_HOST} -e "create database zabbix character set utf8;"
mysql -uroot -h ${DB_HOST} -e "grant all privileges on zabbix.* to zabbix@'${ZABBIX_SERVER_IP}' identified by 'zabbix';"
mysql -uroot -h ${DB_HOST} zabbix < /usr/share/zabbix-server-mysql/schema.sql
mysql -uroot -h ${DB_HOST} zabbix < /usr/share/zabbix-server-mysql/images.sql
mysql -uroot -h ${DB_HOST} zabbix < /usr/share/zabbix-server-mysql/data.sql

cat <<EOF > alter_table.sql
ALTER TABLE acknowledges ROW_FORMAT=COMPRESSED;
ALTER TABLE actions ROW_FORMAT=COMPRESSED;
ALTER TABLE alerts ROW_FORMAT=COMPRESSED;
ALTER TABLE application_template ROW_FORMAT=COMPRESSED;
ALTER TABLE applications ROW_FORMAT=COMPRESSED;
ALTER TABLE auditlog ROW_FORMAT=COMPRESSED;
ALTER TABLE auditlog_details ROW_FORMAT=COMPRESSED;
ALTER TABLE autoreg_host ROW_FORMAT=COMPRESSED;
ALTER TABLE conditions ROW_FORMAT=COMPRESSED;
ALTER TABLE config ROW_FORMAT=COMPRESSED;
ALTER TABLE dbversion ROW_FORMAT=COMPRESSED;
ALTER TABLE dchecks ROW_FORMAT=COMPRESSED;
ALTER TABLE dhosts ROW_FORMAT=COMPRESSED;
ALTER TABLE drules ROW_FORMAT=COMPRESSED;
ALTER TABLE dservices ROW_FORMAT=COMPRESSED;
ALTER TABLE escalations ROW_FORMAT=COMPRESSED;
ALTER TABLE events ROW_FORMAT=COMPRESSED;
ALTER TABLE expressions ROW_FORMAT=COMPRESSED;
ALTER TABLE functions ROW_FORMAT=COMPRESSED;
ALTER TABLE globalmacro ROW_FORMAT=COMPRESSED;
ALTER TABLE globalvars ROW_FORMAT=COMPRESSED;
ALTER TABLE graph_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE graph_theme ROW_FORMAT=COMPRESSED;
ALTER TABLE graphs ROW_FORMAT=COMPRESSED;
ALTER TABLE graphs_items ROW_FORMAT=COMPRESSED;
ALTER TABLE group_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE group_prototype ROW_FORMAT=COMPRESSED;
ALTER TABLE groups ROW_FORMAT=COMPRESSED;
ALTER TABLE history ROW_FORMAT=COMPRESSED;
ALTER TABLE history_log ROW_FORMAT=COMPRESSED;
ALTER TABLE history_str ROW_FORMAT=COMPRESSED;
ALTER TABLE history_str_sync ROW_FORMAT=COMPRESSED;
ALTER TABLE history_sync ROW_FORMAT=COMPRESSED;
ALTER TABLE history_text ROW_FORMAT=COMPRESSED;
ALTER TABLE history_uint ROW_FORMAT=COMPRESSED;
ALTER TABLE history_uint_sync ROW_FORMAT=COMPRESSED;
ALTER TABLE host_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE host_inventory ROW_FORMAT=COMPRESSED;
ALTER TABLE hostmacro ROW_FORMAT=COMPRESSED;
ALTER TABLE hosts ROW_FORMAT=COMPRESSED;
ALTER TABLE hosts_groups ROW_FORMAT=COMPRESSED;
ALTER TABLE hosts_templates ROW_FORMAT=COMPRESSED;
ALTER TABLE housekeeper ROW_FORMAT=COMPRESSED;
ALTER TABLE httpstep ROW_FORMAT=COMPRESSED;
ALTER TABLE httpstepitem ROW_FORMAT=COMPRESSED;
ALTER TABLE httptest ROW_FORMAT=COMPRESSED;
ALTER TABLE httptestitem ROW_FORMAT=COMPRESSED;
ALTER TABLE icon_map ROW_FORMAT=COMPRESSED;
ALTER TABLE icon_mapping ROW_FORMAT=COMPRESSED;
ALTER TABLE ids ROW_FORMAT=COMPRESSED;
ALTER TABLE images ROW_FORMAT=COMPRESSED;
ALTER TABLE interface ROW_FORMAT=COMPRESSED;
ALTER TABLE interface_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE item_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE items ROW_FORMAT=COMPRESSED;
ALTER TABLE items_applications ROW_FORMAT=COMPRESSED;
ALTER TABLE maintenances ROW_FORMAT=COMPRESSED;
ALTER TABLE maintenances_groups ROW_FORMAT=COMPRESSED;
ALTER TABLE maintenances_hosts ROW_FORMAT=COMPRESSED;
ALTER TABLE maintenances_windows ROW_FORMAT=COMPRESSED;
ALTER TABLE mappings ROW_FORMAT=COMPRESSED;
ALTER TABLE media ROW_FORMAT=COMPRESSED;
ALTER TABLE media_type ROW_FORMAT=COMPRESSED;
ALTER TABLE node_cksum ROW_FORMAT=COMPRESSED;
ALTER TABLE nodes ROW_FORMAT=COMPRESSED;
ALTER TABLE opcommand ROW_FORMAT=COMPRESSED;
ALTER TABLE opcommand_grp ROW_FORMAT=COMPRESSED;
ALTER TABLE opcommand_hst ROW_FORMAT=COMPRESSED;
ALTER TABLE opconditions ROW_FORMAT=COMPRESSED;
ALTER TABLE operations ROW_FORMAT=COMPRESSED;
ALTER TABLE opgroup ROW_FORMAT=COMPRESSED;
ALTER TABLE opmessage ROW_FORMAT=COMPRESSED;
ALTER TABLE opmessage_grp ROW_FORMAT=COMPRESSED;
ALTER TABLE opmessage_usr ROW_FORMAT=COMPRESSED;
ALTER TABLE optemplate ROW_FORMAT=COMPRESSED;
ALTER TABLE profiles ROW_FORMAT=COMPRESSED;
ALTER TABLE proxy_autoreg_host ROW_FORMAT=COMPRESSED;
ALTER TABLE proxy_dhistory ROW_FORMAT=COMPRESSED;
ALTER TABLE proxy_history ROW_FORMAT=COMPRESSED;
ALTER TABLE regexps ROW_FORMAT=COMPRESSED;
ALTER TABLE rights ROW_FORMAT=COMPRESSED;
ALTER TABLE screens ROW_FORMAT=COMPRESSED;
ALTER TABLE screens_items ROW_FORMAT=COMPRESSED;
ALTER TABLE scripts ROW_FORMAT=COMPRESSED;
ALTER TABLE service_alarms ROW_FORMAT=COMPRESSED;
ALTER TABLE services ROW_FORMAT=COMPRESSED;
ALTER TABLE services_links ROW_FORMAT=COMPRESSED;
ALTER TABLE services_times ROW_FORMAT=COMPRESSED;
ALTER TABLE sessions ROW_FORMAT=COMPRESSED;
ALTER TABLE slides ROW_FORMAT=COMPRESSED;
ALTER TABLE slideshows ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmap_element_url ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmap_url ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmaps ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmaps_elements ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmaps_link_triggers ROW_FORMAT=COMPRESSED;
ALTER TABLE sysmaps_links ROW_FORMAT=COMPRESSED;
ALTER TABLE timeperiods ROW_FORMAT=COMPRESSED;
ALTER TABLE trends ROW_FORMAT=COMPRESSED;
ALTER TABLE trends_uint ROW_FORMAT=COMPRESSED;
ALTER TABLE trigger_depends ROW_FORMAT=COMPRESSED;
ALTER TABLE trigger_discovery ROW_FORMAT=COMPRESSED;
ALTER TABLE triggers ROW_FORMAT=COMPRESSED;
ALTER TABLE user_history ROW_FORMAT=COMPRESSED;
ALTER TABLE users ROW_FORMAT=COMPRESSED;
ALTER TABLE users_groups ROW_FORMAT=COMPRESSED;
ALTER TABLE usrgrp ROW_FORMAT=COMPRESSED;
ALTER TABLE valuemaps ROW_FORMAT=COMPRESSED;
EOF
mysql -uroot -h ${DB_HOST} zabbix < alter_table.sql

sed -i 's/LogFileSize=0/LogFileSize=5/' /etc/zabbix/zabbix_server.conf
sed -i "s/DBHost=localhost/DBHost=${DB_HOST}/" /etc/zabbix/zabbix_server.conf
sed -i 's/DBName=/DBName=zabbix/' /etc/zabbix/zabbix_server.conf
sed -i 's/DBUser=/DBUser=zabbix/' /etc/zabbix/zabbix_server.conf
sed -i 's/DBPassword=/DBPassword=zabbix/' /etc/zabbix/zabbix_server.conf
cat <<EOF >> /etc/zabbix/zabbix_server.conf

####### NIFTY #######
StartPollers=50
StartPingers=10
StartDiscoverers=10
StartVMwareCollectors=100
VMwareFrequency=60
VMwareCacheSize=512M
CacheSize=128M
StartDBSyncers=8
HistoryCacheSize=64M
TrendCacheSize=64M
HistoryTextCacheSize=128M
ValueCacheSize=128M
Timeout=30
UnreachableDelay=60
LogSlowQueries=3000
EOF

cat <<EOF > /etc/zabbix/web/zabbix.conf.php
<?php
// Zabbix GUI configuration file
global \$DB;

\$DB['TYPE']     = 'MYSQL';
\$DB['SERVER']   = '${DB_HOST}';
\$DB['PORT']     = '0';
\$DB['DATABASE'] = 'zabbix';
\$DB['USER']     = 'zabbix';
\$DB['PASSWORD'] = 'zabbix';

// SCHEMA is relevant only for IBM_DB2 database
\$DB['SCHEMA'] = '';

\$ZBX_SERVER      = 'localhost';
\$ZBX_SERVER_PORT = '10051';
\$ZBX_SERVER_NAME = '${ZABBIX_SERVER_NAME}';

\$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
?>
EOF

service zabbix-server start

sed -i 's/;date\.timezone =/date\.timezone = Asia\/Tokyo/' /etc/php5/apache2/php.ini
service apache2 restart

# Zabbix Agent
sed -i "s/Server=127.0.0.1/Server=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${ZABBIX_SERVER_NAME}/" /etc/zabbix/zabbix_agentd.conf
cat <<EOF >> /etc/zabbix/zabbix_agentd.conf

SourceIP=${ZABBIX_SERVER_IP}
EnableRemoteCommands=1
StartAgents=10
Timeout=30
AllowRoot=1
EOF
service zabbix-agent restart
