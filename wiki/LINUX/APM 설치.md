
# 한국기업 os
 
```bash
sudo apt-mark hold linux-image-generic
sudo apt-mark hold linux-headers-generic
 
sudo apt-mark showhold
 
sudo apt update
sudo apt upgrade -y
```
 
# 한국기업 dir
 
```bash
sudo mkdir -p /home/archive
sudo chown -R hostway.hostway /home/archive
sudo chmod 700 /home/archive
 
sudo mkdir -p /home/backup/httpd
sudo mkdir -p /home/backup/mysql
sudo mkdir -p /home/backup/php
sudo chown -R hostway.hostway /home/backup
sudo chmod 700 /home/backup
 
sudo chown -R hostway.hostway /home/hostway
sudo chown -R erp.erp /home/erp
```
 
# 한국기업 user
 
`user`
 
```bash
sudo usermod -s /bin/bash hostway
echo "hostway:sjaksahffk." | sudo chpasswd
 
sudo rsync -av /etc/skel/ /home/hostway
sudo chown -R hostway.hostway /home/hostway
sudo chmod 700 /home/hostway
 
sudo useradd -m -s /bin/bash erp
echo "erp:zw0975wjddnjs" | sudo chpasswd
```
 
`sudoers`
 
```bash
cat << EOF | sudo tee /etc/sudoers.d/custom
hostway ALL=(ALL) NOPASSWD: ALL
erp ALL=(ALL) NOPASSWD: ALL
EOF
```
 
`service`
 
```bash
sudo groupadd -g 995 web
sudo groupadd -g 996 httpd
sudo groupadd -g 997 mysql
sudo groupadd -g 998 php
 
sudo useradd -r -M -u 996 -g 996 -d /home/httpd -s /sbin/nologin httpd
sudo useradd -r -M -u 997 -g 997 -d /home/mysql -s /sbin/nologin mysql
sudo useradd -r -M -u 998 -g 998 -d /home/php -s /sbin/nologin php
 
sudo usermod -aG web hostway
sudo usermod -aG httpd hostway
sudo usermod -aG mysql hostway
sudo usermod -aG php hostway
sudo usermod -g 995 hostway
 
sudo usermod -aG web erp
sudo usermod -aG httpd erp
sudo usermod -aG mysql erp
sudo usermod -aG php erp
sudo usermod -g 995 erp
 
sudo usermod -aG web httpd
sudo usermod -aG web php
exit
```
 
# 한국기업 hostname
 
```bash
sudo vi /etc/cloud/cloud.cfg
 
preserve_hostname: true
 
sudo hostnamectl set-hostname erp
 
sudo vi /etc/hosts
 
127.0.0.1 erp
```
 
# 한국기업 timezone
 
```bash
sudo timedatectl set-timezone Asia/Seoul
 
timedatectl
```
 
# 한국기업 locale
 
```bash
sudo localectl set-locale LANG=en_US.UTF-8
 
localectl
```
 
# 한국기업 kernel
 
```bash
cat << EOF | sudo tee /etc/modprobe.d/custom.conf
blacklist floppy
EOF
 
sudo update-initramfs -u
 
cat << EOF | sudo tee /etc/sysctl.d/custom.conf
net.ipv4.ip_local_port_range = 11000 60999
EOF
sudo sysctl -p /etc/sysctl.d/custom.conf
sudo sysctl -a | grep ip_local_port_range
sudo sysctl -a | grep tcp_max_tw_buckets
```
 
# 한국기업 package
 
```bash
sudo apt -y install dmidecode pciutils wget net-tools ethtool traceroute rsync telnet net-tools git jq psmisc tcpdump curl socat sysstat atop iotop iftop python3 python3-pip cmake make gcc g++ libexpat1-dev sysbench
 
sudo snap install tcping yq
 
# percona
curl -L  https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb -o percora-release.deb
 
sudo dpkg -i percora-release.deb
sudo apt update
sudo apt -y install percona-xtrabackup-24
```
 
# 한국기업 profile
 
```bash
cat << EOF | sudo tee /etc/profile.d/custom.sh
#!/bin/bash
 
export HISTTIMEFORMAT="[%Y-%m-%d_%H:%M:%S] "
export HISTSIZE=999999
export HISTCONTROL=ignorespace
 
export PATH=\$PATH:/home/httpd/bin
export PATH=\$PATH:/home/mysql/bin
export PATH=\$PATH:/home/php/bin
export PATH=\$PATH:/home/php/sbin
 
umask 0027
 
set +H
EOF
 
source /etc/profile.d/custom.sh
```
 
# 한국기업 logrotate
 
`httpd`
 
```bash
cat << EOF | sudo tee /etc/logrotate.d/httpd
/home/httpd/logs/test.com-access_log
{
  daily
  rotate 90
  copytruncate
  nocompress
  missingok
  dateext
  notifempty
}
 
/home/httpd/logs/test.com-error_log
{
  monthly
  rotate 3
  copytruncate
  nocompress
  missingok
  dateext
  notifempty
}
EOF
```
 
`mysql`
 
```bash
cat << EOF | sudo tee /etc/logrotate.d/mysql
/home/mysql/log/mysql.log
{
  monthly
  rotate 3
  copytruncate
  nocompress
  missingok
  dateext
  notifempty
}
EOF
```
 
`php`
 
```bash
cat << EOF | sudo tee /etc/logrotate.d/php
/home/php/log/php.log
/home/php/log/php-fpm.log
{
  monthly
  rotate 3
  copytruncate
  nocompress
  missingok
  dateext
  notifempty
}
EOF
```
 
# ------------------------------------------------
 
# 한국기업 daemon
 
# 한국기업 daemon-time
 
```bash
sudo apt -y install chrony
 
sudo systemctl enable --now chrony
sudo systemctl status chrony
```
 
# ------------------------------------------------
 
# 한국기업 monitor
 
```bash
sudo mkdir -p /home/monitor/sysstat
sudo mkdir -p /home/monitor/atop
sudo mkdir -p /home/monitor/journal
 
sudo find /home/monitor -type d -exec sudo chmod 750 {} \;
sudo chown -R hostway.hostway /home/monitor
sudo chmod 700 /home/monitor
```
 
# 한국기업 monitor-sysstat
 
```bash
sudo vi /etc/cron.d/sysstat
 
* * * * * root command -v debian-sa1 > /dev/null && debian-sa1 1 1
 
sudo vi /etc/sysstat/sysstat
 
HISTORY=90
COMPRESSAFTER=90
SADC_OPTIONS="-S XALL"
SA_DIR=/home/monitor/sysstat
 
sudo vi /usr/lib/systemd/system/sysstat-collect.timer
 
[Timer]
OnCalendar=*:00/1
 
sudo systemctl daemon-reload
sudo systemctl enable --now sysstat
sudo systemctl status --no-pager sysstat
 
sar -f /home/monitor/sysstat/sa20231023
```
 
# 한국기업 monitor-atop
 
```bash
cat << EOF | sudo tee /etc/default/atop
LOGOPTS="-R"
LOGINTERVAL=90
LOGGENERATIONS=30
LOGPATH=/home/monitor/atop
EOF
 
sudo systemctl restart atop
sudo systemctl status --no-pager atop
 
atop -r /home/monitor/atop/atop_20231023
```
 
# 한국기업 monitor-journal
 
```bash
sudo mkdir -p /etc/systemd/journald.conf.d
cat << EOF | sudo tee /etc/systemd/journald.conf.d/custom.conf
[Journal]
Storage=persistent
SystemMaxUse=5G
EOF
 
sudo systemctl restart systemd-journald
sudo systemctl status --no-pager systemd-journald
```
 
# ------------------------------------------------
 
# 한국기업 httpd
 
# 한국기업 httpd-install
 
```bash
sudo apt -y install libssl-dev libpcre3 libpcre3-dev
 
curl -L  https://archive.apache.org/dist/apr/apr-1.7.4.tar.gz -o apr-1.7.4.tar.gz
curl -L  https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.gz -o apr-util-1.6.3.tar.gz
curl -L  http://archive.apache.org/dist/httpd/httpd-2.4.57.tar.gz -o httpd-2.4.57.tar.gz
 
tar xvzf apr-1.7.4.tar.gz
tar xvzf apr-util-1.6.3.tar.gz
tar xvzf httpd-2.4.57.tar.gz
 
sudo mv *.tar.gz /home/archive/
 
sudo mv ~/apr-1* ~/apr
sudo mv ~/apr-util-* ~/apr-util
sudo mv ~/apr ~/httpd-*/srclib/
sudo mv ~/apr-util ~/httpd-*/srclib/
 
# httpd
cd ~/httpd-*
sudo sh configure --prefix=/home/httpd \
--enable-modules=most \
--enable-mods-shared=all \
--enable-ssl \
--enable-proxy \
--enable-so \
--with-included-apr \
--with-pcre
sudo make -j $(nproc) && sudo make install
 
sudo mv httpd-* /home/archive/
 
cat << EOF | sudo tee /etc/systemd/system/httpd.service
[Unit]
Description=apache http service daemon
After=network.target syslog.target
 
[Service]
Type=forking
User=httpd
Group=httpd
 
ExecStart=/home/httpd/bin/apachectl -k start
ExecStop=/home/httpd/bin/apachectl -k stop
ExecReload=/home/httpd/bin/apachectl -k graceful
 
[Install]
WantedBy=multi-user.target
EOF
 
sudo mkdir /etc/systemd/system/httpd.service.d
cat << EOF | sudo tee /etc/systemd/system/httpd.service.d/custom.conf
[Service]
LimitNOFILE=infinity
LimitNPROC=infinity
LimitMEMLOCK=infinity
EOF
```
 
# 한국기업 httpd-conf
 
```bash
sudo vi /home/httpd/conf/httpd.conf
 
User httpd
Group httpd
 
ServerName 127.0.0.1:80
 
Include /home/httpd/conf.d/*.conf
 
<Directory "/home/httpd/htdocs">
    Options FollowSymLinks
</Directory>
## Options Indexes 제거
 
<Directory "/home/httpd/cgi-bin">
    AllowOverride None
    Options None
    # Require all granted
</Directory>
## Require all granted 제거
 
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
```
 
```bash
sudo mkdir -p /home/httpd/conf.d
cat << EOF | sudo tee /home/httpd/conf.d/custom.conf
<Virtualhost *:80>
  ServerName test.com
 
  KeepAliveTimeout 5
 
  DocumentRoot /home/httpd/htdocs
 
  LogLevel warn
  ErrorLog "/home/httpd/logs/test.com-error_log"
  CustomLog "/home/httpd/logs/test.com-access_log" custom
 
  ProxyTimeout 30
 
  <FilesMatch \.php$>
    SetHandler "proxy:fcgi://127.0.0.1:9000"
  </FilesMatch>
 
  <Directory "/home/httpd/htdocs/*">
    AllowOverride None
    Options FollowSymLinks
    Require method GET
  </Directory>
</Virtualhost>
 
# module
<IfModule !rewrite_module>
LoadModule rewrite_module modules/mod_rewrite.so
</IfModule>
 
<IfModule !proxy_module>
LoadModule proxy_module modules/mod_proxy.so
</IfModule>
 
<IfModule !proxy_fcgi_module>
LoadModule proxy_fcgi_module modules/mod_proxy_fcgi.so
</IfModule>
 
# performance
Timeout 60
KeepAlive on
MaxKeepAliveRequests 0
 
<Ifmodule mpm_event_module>
  ServerLimit 500
  StartServers 50
  MaxRequestWorkers 10000
  ThreadsPerChild 20
  MinSpareThreads 1000
</IfModule>
 
# security
ServerTokens Prod
ServerSignature Off
TraceEnable Off
 
# directory
<Directory "/home/httpd/htdocs/res-infra/*">
  AllowOverride None
  Options FollowSymLinks
  Require ip 127.0.0.1/32
</Directory>
 
# error
ErrorDocument 400 /res-infra/error/error.html
ErrorDocument 401 /res-infra/error/error.html
ErrorDocument 402 /res-infra/error/error.html
ErrorDocument 403 /res-infra/error/error.html
ErrorDocument 404 /res-infra/error/error.html
ErrorDocument 405 /res-infra/error/error.html
ErrorDocument 406 /res-infra/error/error.html
ErrorDocument 407 /res-infra/error/error.html
ErrorDocument 408 /res-infra/error/error.html
ErrorDocument 409 /res-infra/error/error.html
ErrorDocument 500 /res-infra/error/error.html
ErrorDocument 501 /res-infra/error/error.html
ErrorDocument 502 /res-infra/error/error.html
ErrorDocument 503 /res-infra/error/error.html
ErrorDocument 504 /res-infra/error/error.html
 
<LocationMatch "/res-infra/error/error.html">
  RewriteEngine On
  RewriteCond %{ENV:REDIRECT_STATUS} =""
  RewriteRule .* - [L,R=403]
</LocationMatch>
EOF
```
 
# 한국기업 httpd-htdocs
 
```bash
sudo rm -f /home/httpd/htdocs/index.html
 
sudo mkdir -p /home/httpd/htdocs/res-infra/check
cat << EOF | sudo tee /home/httpd/htdocs/res-infra/check/ping
pong
EOF
 
sudo mkdir -p /home/httpd/htdocs/res-infra/error
cat << EOF | sudo tee /home/httpd/htdocs/res-infra/error/error.html
Unexpected action or issues occurred
EOF
```
 
# 한국기업 httpd-oper
 
```bash
sudo chown -R httpd.httpd /home/httpd
sudo chown httpd.web /home/httpd
sudo chmod 750 /home/httpd
 
sudo chown root.root /home/httpd/bin/httpd
sudo chmod 755 /home/httpd/bin/httpd
sudo chmod u+s /home/httpd/bin/httpd
 
sudo chown -R hostway.web /home/httpd/htdocs
sudo chown httpd.web /home/httpd/htdocs
sudo chmod 770 /home/httpd/htdocs
 
sudo chown root.root /home/httpd/bin/apachectl
sudo chmod 755 /home/httpd/bin/apachectl
sudo chmod u+s /home/httpd/bin/apachectl
 
sudo systemctl daemon-reload
sudo systemctl enable --now httpd
sudo systemctl status --no-pager httpd
```
 
# ------------------------------------------------
 
# 한국기업 mysql
 
# 한국기업 mysql-install
 
```bash
sudo apt -y install libncurses-dev libncurses5 libncurses5-dev
 
curl -L  https://downloads.mysql.com/archives/get/p/23/file/mysql-5.7.14-linux-glibc2.5-x86_64.tar.gz -o mysql-5.7.14-linux-glibc2.5-x86_64.tar.gz
 
tar xvzf mysql-5.7.14-linux-glibc2.5-x86_64.tar.gz
 
sudo mv *.tar.gz /home/archive/
 
sudo mv mysql-*/ /home/mysql
 
cat << EOF | sudo tee /etc/systemd/system/mysql.service
[Unit]
Description=Mysql Server
After=network.target syslog.target
 
[Service]
Type=forking
User=mysql
Group=mysql
 
ExecStart=/home/mysql/bin/mysqld --defaults-file=/etc/my.cnf --user=mysql --socket=/home/mysql/mysql.sock --daemonize
ExecStop=/home/mysql/bin/mysqladmin shutdown
 
[Install]
WantedBy=multi-user.target
EOF
 
sudo mkdir /etc/systemd/system/mysql.service.d
cat << EOF | sudo tee /etc/systemd/system/mysql.service.d/custom.conf
[Service]
LimitNOFILE=infinity
LimitNPROC=infinity
LimitMEMLOCK=infinity
EOF
 
# mysqld -v --help
 
# cmake \
# -DCMAKE_INSTALL_PREFIX=/home/mysql \
# -DMYSQL_DATADIR=/home/mysql/data \
# -DMYSQL_UNIX_ADDR=/home/mysql/mysql.sock \
# -DSYSCONFDIR=/home/mysql \
# -DMYSQL_TCP_PORT=3306 \
# -DMYSQL_USER=mysql \
# -DDEFAULT_CHARSET=utf8 \
# -DDEFAULT_COLLATION=utf8_general_ci \
# -DWITH_EXTRA_CHARSETS=all \
# -DENABLED_LOCAL_INFILE=1 \
# -DWITH_INNOBASE_STORAGE_ENGINE=1 \
# -DWITH_ARCHIVE_STORAGE_ENGINE=1 \
# -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
# -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/home/mysql/boost
 
# make -j $CORE && make install
```
 
# 한국기업 mysql-conf
 
```bash
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql
 
mysql_tzinfo_to_sql  /usr/share/zoneinfo/Asia/Seoul KST
```
 
```bash
sudo mkdir -p /home/mysql/log
sudo mkdir -p /home/mysql/secure
cat << EOF | sudo tee /etc/my.cnf
[mysqld]
basedir=/home/mysql
datadir=/home/mysql/data
socket=/home/mysql/mysql.sock
symbolic-links=0
 
bind-address = 127.0.0.1
 
log-error=/home/mysql/log/mysql.log
pid-file=/home/mysql/log/mysql.pid
 
character-set-server = utf8
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
 
default-storage-engine = InnoDB
default-time-zone = Asia/Seoul
log_timestamps = SYSTEM
 
max_connections = 1000
max_prepared_stmt_count = 32768
innodb_buffer_pool_size = 5G
 
explicit_defaults_for_timestamp = 1
secure-file-priv = /home/mysql/secure
skip_name_resolve
 
[mysqld_safe]
 
[mysql]
socket=/home/mysql/mysql.sock
 
[mysqladmin]
socket=/home/mysql/mysql.sock
EOF
 
cat << EOF | sudo tee /etc/logrotate.d/mysql
/home/mysql/log/mysql.log {
        # create 600 mysql mysql
        notifempty
        daily
        rotate 90
        missingok
    postrotate
        if test -x /home/mysql/bin/mysqladmin && \
           /home/mysql/bin/mysqladmin ping &>/dev/null
        then
           /home/mysql/bin/mysqladmin flush-logs
        fi
    endscript
}
EOF
 
sudo su - -c "mysqld --initialize-insecure --user=mysql"
 
mysql_secure_installation
# VALIDATE PASSWORD: No
 
mysql_config_editor set --login-path=local --host=127.0.0.1 --user=root --password
```
 
# 한국기업 mysql-oper
 
```bash
sudo chown -R mysql.mysql /home/mysql
sudo chmod 750 /home/mysql
sudo chmod 750 /home/mysql/secure
sudo chmod 750 /home/mysql/log
 
sudo systemctl daemon-reload
sudo systemctl enable --now mysql
sudo systemctl status --no-pager mysql
 
mysql --login-path=local
 
mysql> SELECT VERSION();
mysql> SHOW ENGINES;
mysql> SHOW VARIABLES LIKE 'local_infile';
mysql> SHOW ENGINE INNODB STATUS;
```
 
# ------------------------------------------------
 
# 한국기업 php
 
# 한국기업 php-install
 
```bash
sudo apt -y install libxml2-dev libssl-dev libcurl4-openssl-dev zlib1g-dev libgd-dev libwebp-dev libicu-dev
 
curl -L  https://www.php.net/distributions/php-7.1.9.tar.gz -o php-7.1.9.tar.gz
 
tar xvzf php-7.1.9.tar.gz
 
sudo mv *.tar.gz /home/archive/
 
cd php-*
 
./configure \
--prefix=/home/php \
--with-apxs2=/home/httpd/bin/apxs \
--disable-debug \
--enable-sockets \
--enable-opcache \
--enable-fpm \
--enable-mbstring \
--enable-mbregex \
--enable-zip \
--with-pdo-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-zlib \
--with-curl \
--with-gd \
--with-webp-dir=/usr/include \
--with-jpeg-dir=/usr/include
 
sudo make -j $(nproc) && sudo make install
 
cat << EOF | sudo tee /etc/systemd/system/php-fpm.service
[Unit]
Description=PHP FastCGI Process Manager
After=network.target syslog.target
 
[Service]
Type=forking
User=php
Group=php
 
ExecStart=/home/php/sbin/php-fpm
 
[Install]
WantedBy=multi-user.target
EOF
```
 
# 한국기업 php-conf
 
```bash
sudo mkdir -p /home/php/log
sudo cp /home/archive/php-7.1.9/php.ini-production /home/php/lib/php.ini
sudo cp /home/php/etc/php-fpm.conf.default /home/php/etc/php-fpm.conf
cat << EOF | sudo tee /home/php/etc/php-fpm.d/custom.conf
[global]
pid = /home/php/log/php-fpm.pid
error_log = /home/php/log/php-fpm.log
log_level = warning
daemonize = yes
 
[php]
listen = 127.0.0.1:9000
 
pm = dynamic
pm.max_children = 200
pm.start_servers = 10
pm.min_spare_servers = 10
pm.max_spare_servers = 20
 
php_value[include_path] = "/home/php/lib/php.ini"
EOF
```
 
`php.ini`
 
```ini
[PHP]
short_open_tag = On
 
post_max_size = 20M
 
upload_max_filesize = 20M
 
error_log = /home/php/log/php.log
 
expose_php = Off
 
[Date]
date.timezone = "Asia/Seoul"
```
 
# 한국기업 php-oper
 
```bash
sudo chown -R php.php /home/php
sudo chmod 750 /home/php
 
sudo chmod 640 /home/php/log/php-fpm.log
 
sudo systemctl daemon-reload
sudo systemctl enable --now php-fpm
sudo systemctl status --no-pager php-fpm
```
 
# ------------------------------------------------
