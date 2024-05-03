
## 의존성 설치 ##
````
[root@]#amazon-linux-extras install epel
[root@]#sudo yum install fping  # CentOS, RHEL
[root@]#sudo yum install fping
[root@]#sudo yum install OpenIPMI-libs net-snmp-libs  # CentOS, RHEL
[root@]#sudo yum install unixODBC  # CentOS, RHEL
 ````
 
## Proxy-mysql 패키지 설치 ##
````
[root@]#rpm -Uvh https://repo.zabbix.com/zabbix/5.4/rhel/7/x86_64/zabbix-proxy-mysql-5.4.4-1.el7.x86_64.rpm
[root@]#yum clean all 
[root@]#yum install zabbix-proxy-mysql
 ````
 

## Proxy-Scripts 설치 ##
````
[root@]#wget https://repo.zabbix.com/zabbix/5.4/rhel/7/x86_64/zabbix-sql-scripts-5.4.4-1.el7.noarch.rpm 
[root@]#rpm -Uvh zabbix-sql-scripts-5.4.4-1.el7.noarch.rpm 
[root@]#cd /usr/share/doc/zabbix-sql-scripts/mysql/ 
[root@]#gunzip schema.sql.gz
 ````

 
## MariaDB 설치 및 설정 ##
````
[root@]#sudo tee /etc/yum.repos.d/mariadb.repo<<EOF 
[mariadb]
name = MariaDB 
baseurl = http://yum.mariadb.org/10.6/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
 ````


[root@]#yum -y install MariaDB-server MariaDB-client \
[root@]#systemctl start mariadb \
[root@]#systemctl enable mariadb \
 
[root@]#mysql -u root -p 
 
mariadb>create database zabbix_proxy character set utf8 collate utf8_bin; \
mariadb>grant all privileges on *.* to zabbix@localhost identified by 'QWer1234!@'; \
mariadb>FLUSH PRIVILEGES; \
mariadb>use zabbix_proxy; \
mariadb>mysql source /usr/share/doc/zabbix-sql-scripts/mysql/schema.sql \
 
[root@]#cp /etc/my.cnf /etc/my.cnf.origin \
[root@]#sudo tee /etc/my.cnf<<EOF \
````
# This group is read both by the client and the server
# use it for options that affect everything
#
[client-server]
 
#
# include *.cnf from the config directory
#
!includedir /etc/my.cnf.d
 
# vi /etc/my.cnf
 
[mysqld]
#general_log=ON
log-error=/var/lib/mysql/error.log
max_connections = 1000
innodb_file_per_table=ON
innodb_buffer_pool_size=500M
thread_cache_size=4
EOF
 ````
 

[root@]#systemctl restart mariadb \
[root@]#systemctl status mariadb 
 


## Zabbix Proxy 설정 및 구동 ##
````
[root@]#cp /etc/zabbix/zabbix_proxy.conf /etc/zabbix/zabbix_proxy.conf.origin
[root@]#sudo tee /etc/zabbix/zabbix_proxy.conf<<EOF
ProxyMode=0
Server=211.115.223.215
ServerPort=10051
Hostname=[!!!!!!!!!실제 호스트 네임으로!!!!!!!]
LogFile=/var/log/zabbix/zabbix_proxy.log
LogFileSize=0
DebugLevel=3
PidFile=/var/run/zabbix/zabbix_proxy.pid
SocketDir=/var/run/zabbix
HeartbeatFrequency=60
ConfigFrequency=60
StartPollers=50
StartPollersUnreachable=20
StartDiscoverers=60
DBName=zabbix_proxy
DBUser=zabbix
DBPassword=QWer1234!@
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
Timeout=4
LogSlowQueries=3000
StatsAllowedIP=127.0.0.1
EOF
 ````

 ````
[root@]#systemctl restart zabbix-proxy.service
[root@]#systemctl restart mariadb
 ````



## Zabbix Agent 설정 및 구동 ##
````
[root@]#wget https://repo.zabbix.com/zabbix/5.4/rhel/7/x86_64/zabbix-agent-5.4.4-1.el7.x86_64.rpm
[root@]#rpm -Uvh zabbix-agent-5.4.4-1.el7.x86_64.rpm
[root@]#cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.origin
[root@]#sudo tee /etc/zabbix/zabbix_agentd.conf<<EOF
PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
DebugLevel=3
Server=211.115.223.215
ServerActive=211.115.223.215
Hostname=[!!!!!!!!!실제 호스트 네임으로!!!!!!!]
Include=/etc/zabbix/zabbix_agentd.d/*.conf
EOF
````