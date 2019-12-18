#!/bin/bash


expect <<EOF

    set timeout 1
    spawn yum install supervisor
    expect "/N]:" { send "y\r";exp_continue;}   
    expect "/N]:" { send "y\r";exp_continue;}   
    expect "]#" {exit;}
EOF
exit


