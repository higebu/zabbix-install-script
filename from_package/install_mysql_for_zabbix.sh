#!/bin/bash

ZABBIX_SERVER_IP={YOUR_ZABBIX_SERVER_IP}

cat <<EOF >> /etc/sysctl.conf
net.ipv4.neigh.default.gc_thresh1 = 512
net.ipv4.neigh.default.gc_thresh2 = 2048
net.ipv4.neigh.default.gc_thresh3 = 4096
fs.file-max = 65536
EOF
sysctl -p

ulimit -n 65536
cat <<EOF >> /etc/security/limits.conf
* soft nofile 65536
* hard nofile 65536
EOF


# Format /dev/sdb and mount as /mysql
aptitude -y install xfsprogs
mkfs.xfs /dev/sdb
mkdir /mysql
cat <<EOF >> /etc/fstab
/dev/sdb /mysql xfs defaults,noatime 1 2
EOF
mount /mysql

# Install MySQL
aptitude -y install libaio1
wget http://jaist.dl.sourceforge.net/project/mysql.mirror/MySQL%205.6.14/mysql-5.6.14-debian6.0-x86_64.deb
dpkg -i mysql-5.6.14-debian6.0-x86_64.deb

groupadd mysql
useradd -r -g mysql mysql
install -o mysql -g mysql -d /mysql
/opt/mysql/server-5.6/scripts/mysql_install_db --user=mysql --datadir=/mysql

service mysql stop

cp /opt/mysql/server-5.6/support-files/mysql.server /etc/init.d/mysql
update-rc.d mysql defaults

sed -i 's/sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES/sql_mode=NO_ENGINE_SUBSTITUTION/' /opt/mysql/server-5.6/my.cnf
cat <<EOF >> /etc/my.cnf
[client]
port            = 3306
socket          = /var/lib/mysql/mysql.sock

[mysqld]
port            = 3306
socket          = /var/lib/mysql/mysql.sock
datadir         = /mysql
max_connections = 1024
max_connect_errors=1024
skip-external-locking
table_open_cache = 4000
key_buffer_size = 16M
read_buffer_size = 256k
read_rnd_buffer_size = 512k
join_buffer_size = 256k
thread_concurrency = 8
skip-character-set-client-handshake
slow-query-log
slow-query-log-file = /log/mysql-slow.log
long_query_time = 3
log_queries_not_using_indexes
#open_files_limit = 8192
#log-bin=mysql-bin
#binlog_format = MIXED
#max_binlog_size = 128M
#expire_logs_days = 10
server-id       = 1
innodb_data_home_dir = /mysql
innodb_buffer_pool_size = 12G
innodb_buffer_pool_instances = 16
innodb_additional_mem_pool_size = 16M
innodb_file_format = Barracuda
innodb_file_per_table
innodb_autoextend_increment = 64M
# innodb_thread_concurrency = 0
innodb_commit_concurrency = 6
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 16M
innodb_log_file_size = 512M
innodb_log_files_in_group = 2
innodb_flush_method = O_DIRECT

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

service mysql start
/opt/mysql/server-5.6/bin/mysqladmin -u root password ''

cat <<EOF >> /etc/profile.d/mysql.sh
PATH="/opt/mysql/server-5.6/bin:$PATH"
MANPATH="/opt/mysql/server-5.6/man:$MANPATH"
EOF
source /etc/profile.d/mysql.sh

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'${ZABBIX_SERVER_IP}' IDENTIFIED BY '' WITH GRANT OPTION;"

# Zabbix Agent Install
aptitude install zabbix-agent

sed -i "s/Server=127.0.0.1/Server=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$(hostname)/" /etc/zabbix/zabbix_agentd.conf
cat <<EOF >> /etc/zabbix/zabbix_agentd.conf

SourceIP=$(ifconfig eth0 | grep 'inet addr' | awk '{print $2}' | awk -F':' '{print $2}')
EnableRemoteCommands=1
StartAgents=10
Timeout=30
AllowRoot=1
EOF

service zabbix-agent restart
