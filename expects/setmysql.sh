#!/bin/bash

password=$1
echo $password

expect <<EOF
    set timeout 1
    spawn mysql -u root -p
 expect {
        "Enter password:" {send "$password\r"; exp_continue;}
    }
    expect "mysql>" { send "set password=password('swZHhai2019db&#');\r"; }
    expect "mysql>" { send " grant all privileges on *.* to root@'%' identified by 'root';\r"; }
    expect "mysql>" { send "flush privileges;\r"; }
    expect "mysql>" { send "create databases dlms;\r"; }
    expect "mysql>" { send "use dlms;\r"; }    
    expect "mysql>" { send "set names utf8;\r"; }
    expect "mysql>" { send "source /opt/org.lowan.java/dlms.sql;\r"; }
    
   expect "mysql>" { send "use mysql;\r"; }
    expect "mysql>" { send "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'swZHhai2019db&#' WITH GRANT OPTION;\r"; }
    expect "mysql>" { send "flush privileges;\r"; }
    expect "mysql>" { send "exit;\r"; }
    expect "mysql>" { exit;}
EOF
exit
#    expect {
#        "Enter password:" {send "$tempassword\r"; exp_continue;}
#    }
#  
