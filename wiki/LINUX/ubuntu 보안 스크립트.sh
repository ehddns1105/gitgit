##계정 잠금 임계값 등 설정 , faillock


#!/bin/bash
 
# install libpam-pwquality package
apt -y install libpam-pwquality
 
sleep 1
 
sudo sed -i 's/^password\s\+\[success=1\sdefault=ignore\]\s\+pam_unix\.so\sobscure\suse_authtok\s\+try_first_pass\s\+yescrypt/password [success=1 default=ignore] pam_unix.so obscure use_authtok try_first_pass yescrypt sha512 remember=2/' /etc/pam.d/common-password
sudo sed -i '/^auth\s\+\[success=1\sdefault=ignore\]\s\+pam_unix\.so\snullok/s/^auth\s\+\[success=1\sdefault=ignore\]\s\+pam_unix\.so\snullok/auth    required                        pam_faillock.so preauth silent audit deny=4 unlock_time=1800 no_magic_root reset\nauth    [success=1 default=ignore]      pam_unix.so nullok\nauth    [default=die]                   pam_faillock.so authfail audit deny=4 unlock_time=1800\nauth    sufficient                      pam_faillock.so authsucc audit deny=4 unlock_time=1800/g' /etc/pam.d/common-auth
sudo sed -i 's/PASS_MAX_DAYS\s*99999/PASS_MAX_DAYS\t90/g; s/PASS_MIN_DAYS\s*0/PASS_MIN_DAYS\t1/g; s/PASS_WARN_AGE\s*7/PASS_WARN_AGE\t7/g;' /etc/login.defs
 
sleep 1
 
cat <<EOF >> /etc/security/pwquality.conf
#password policy
minlen = 8                                                                                                                                                                  
minclass = 3
lcredit = -1
dcredit = -1
ocredit = -1
EOF
 
sleep 1
 
chmod 400 /etc/shadow
chmod 700 /usr/bin/last
chmod 700 /sbin/ifconfig /usr/sbin/ip /usr/bin/netstat
chmod 755 /etc/profile
chmod 600 /etc/hosts /etc/hosts.allow /etc/hosts.deny /etc/passwd- /etc/services /var/log/wtmp /var/log/btmp
 
sleep 1
 
echo 'umask 022' | sudo tee -a /etc/profile
echo 'export umask' | sudo tee -a /etc/profile
echo 'export TMOUT=1800' | sudo tee -a /etc/profile