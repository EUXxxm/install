#!/bin/bash
#password="swZHhai2019db&#"
password=$1



supervisorjar=$(rpm -qa|grep -i supervisor )
#yum remove $supervisorjar


echo "delete $supervisorjar"
expect <<EOF

    set timeout 1
    spawn  yum remove $supervisorjar 
    expect "/N]:" { send "y\r";exp_continue;}	
    expect "/N]:" { send "y\r";exp_continue;}	
    expect "]#" {exit;}
EOF
exit

#    expect {
#     "Enter password:" {send "$password\r";exp_continue }
#    }
#    expect "kjash" {send "show databases;\r";}
#    expect "mysql>" { send "show databases;\r";}
#    expect "mysql>" { send "use mysql;\r"; }
#    expect "mysql>" { send "show tables;\r";}

#    expect "mysql>" {exit;}



