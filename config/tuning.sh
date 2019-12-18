#!/bin/bash

##########################################################
sysctl -w fs.file-max=2097152
sysctl -w fs.nr_open=2097152
echo 2097152 > /proc/sys/fs/nr_open


ulimit -n 1048576


sed -i '/fs.file-max = 1048576/d' /etc/sysctl.conf
sed -i '/DefaultLimitNOFILE=1048576/d'  /etc/systemd/system.conf
sed -i '/soft   nofile      1048576/d'  /etc/security/limits.conf
sed -i '/hard   nofile      1048576/d'  /etc/security/limits.conf

echo "fs.file-max = 1048576" >> /etc/sysctl.conf
echo "DefaultLimitNOFILE=1048576" >> /etc/systemd/system.conf
echo "soft   nofile      1048576
hard   nofile      1048576" >> /etc/security/limits.conf


##########################################################
sysctl -w net.core.somaxconn=32768
sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sysctl -w net.core.netdev_max_backlog=16384

sysctl -w net.ipv4.ip_local_port_range='1000 65535'

sysctl -w net.core.rmem_default=262144
sysctl -w net.core.wmem_default=262144
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.core.optmem_max=16777216

#sysctl -w net.ipv4.tcp_mem='16777216 16777216 16777216'
sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'



sysctl -w net.nf_conntrack_max=1000000
sysctl -w net.netfilter.nf_conntrack_max=1000000
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30


sysctl -w net.ipv4.tcp_max_tw_buckets=1048576

sysctl -w net.ipv4.tcp_fin_timeout=15



##################################################################
sed -i '/node.process_limit = 2097152/d' /opt/emqttd-dlms/etc/emq.conf
sed -i '/node.max_ports = 1048576/d' /opt/emqttd-dlms/etc/emq.conf
echo  "node.process_limit = 2097152" >> /opt/emqttd-dlms/etc/emq.conf
echo  "node.max_ports = 1048576">> /opt/emqttd-dlms/etc/emq.conf

##################################################################
sed -i '/listener.tcp.external.acceptors/d' /opt/emqttd-dlms/etc/emq.conf 
echo "listener.tcp.external.acceptors = 64" >> /opt/emqttd-dlms/etc/emq.conf 


##################################################################




