zabbix-install-script
=====================

Zabbix Install Script for Ubuntu.

Install Zabbix Server
---------------------

1. Install MySQL Server
2. Run create_db_for_server.sh
3. Run install_zabbix_server.sh
4. Start Zabbix Server `service zabbix-server start`

Install Zabbix Web
------------------
1. Read install_web.sh and install zabbix-web

Install Zabbix Proxy
--------------------
1. Install MySQL Server
2. Run create_db_for_proxy.sh
3. Run install_zabbix_proxy.sh
4. Start Zabbix Proxy `service zabbix-proxy start`

Install Zabbix Agent
--------------------
1. Run install_zabbix_agent.sh
2. Start Zabbix Agent `service zabbix-agent start`
