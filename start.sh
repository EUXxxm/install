#!/bin/bash

#######################################################################

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] This script must be run as root!" && exit 1


#############################################
echo -e "${yellow}warning:starting install?${plain}"
read -p "[yes|no]>>>" myread 
while [[ $myread != "yes"&&$myread != "no" ]]
do 	
 read -p "[yes|no]>>>" myread
done
if [ ${myread} == "no" ];then
echo OK! 
exit 1
fi
#echo -e  "${yellow}start to configure environment${plain}"
echo -e "${yellow} begining ${plain}"
ins_dir=$(cd $(dirname $0);pwd)

ip_addr=$( ifconfig eth0|grep inet|awk '{print $2}')
install_prepare(){

echo -e "$yellsw prepare to install $plain"
yum-complete-transaction
yum install -y tcl
yum install -y expect
yum install -y wget
./test.sh
phase_finished
}
install_java(){
echo -e "${yellow}java:${plain}"
java -version
echo -e "${yellow}warning:install java se 1.8${plain}"
read -p"[yes|no]>>>" javaread
while [[ $javaread != "yes" && $javaread != "no" ]] 
do
  read -p "[yes|no]>>>" javaread
done
if [ $javaread == "no" ];then 
return 
fi 

rm -f /usr/bin/java
rm -f /etc/alternatives/java

rm -f /usr/bin/javac
rm -f /etc/alternatives/javac

rm -f /usr/bin/jar
rm -f /etc/alternatives/jar
sed -i '/JAVA_HOME/d' /etc/profile
source /etc/profile
rm -rf /opt/jdk1.8.0_181


#set 'export JAVA_HOME=/usr/java/jdk1.8.0_181'
#set 'export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib'
#set 'export PATH=$JAVA_HOME/bin:$PATH'


cd $ins_dir
tar -xvf jdk-8u181-linux-x64.tar
cp jdk1.8.0_181 /opt/ -rf
rm -rf jdk1.8.0_181
echo "export JAVA_HOME=/opt/jdk1.8.0_181
export JRE_HOME=\$JAVA_HOME/jre
export JAVA_PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JRE_HOME/lib/rt.jar:\$CLASSPATH
export PATH=\$JAVA_HOME/bin:\$JRE_HOME/bin:\$PATH" >>/etc/profile

source /etc/profile
ln -s /opt/jdk1.8.0_181/bin/java /usr/sbin/java
ln -s /opt/jdk1.8.0_181/bin/java /usr/bin/java
java -version
echo -e "$green JAVASE1.8 success$plain"
}

install_emqttd(){
echo -e "${yellow}warning:starting  to install emqttd?${plain}"
read -p "[yes|no]>>>" myread2
while [[ $myread2 != "yes"&&$myread2 != "no" ]]
 do
  echo -e "${yellow}warning:starting install?${plain}"
  read -p "[yes|no]>>>" myread2
 done
if [ $myread2 == "no" ] ;then 
return 
fi
cd $ins_dir
#rm emqttd -rf
#wget "https://www.emqx.io/downloads/broker/v2.3.11/emqttd-centos7-v2.3.11.zip"
#unzip "emqttd-centos7-v2.3.11.zip"
tar -xvf emqttd-dlms.tar.gz
rm /opt/emqttd-dlms-t -rf
mv emqttd-dlms /opt/emqttd
rm "emqttd-centos7-v2.3.11.zip"
echo -e "${green}emqttd install success.${plain}"

}

install_zookeeper_kafka(){
echo -e "${yellow}warning:starting to install zookeeper&&kafka?${plain}"
read -p "[yes|no]>>>" myread3
while [[ $myread3 != "yes"&&$myread3 != "no" ]]
 do
  echo -e "${yellow}warning:starting install?${plain}"
  read -p "[yes|no]>>>" myread3
 done
if [ $myread3 == "no" ] ;then
return
fi
cd $ins_dir
echo --------------------------------------------------------------
echo -e "${green}-------------------------start kafka--------------------------${plain}"
cd $ins_dir
wget http://mirror.bit.edu.cn/apache/kafka/2.3.1/kafka_2.11-2.3.1.tgz
tar -xzf kafka_2.11-2.3.1.tgz

rm /opt/kafka -rf
rm /data/kafka-logs -rf
rm /data/zookeeper -rf

mv kafka_2.11-2.3.1 /opt/ 
rm kafka_2.11-2.3.1.tgz
cd /opt/kafka_2.11-2.3.1/config
mv server.properties server.properties-old

cp $ins_dir/config/server.properties /opt/kafka_2.11-2.3.1/config/
sed -i 's/10.10.0.37/'$ip_addr'/g'  server.properties 
mv zookeeper.properties old-zookeeper.properties
cp $ins_dir/config/zookeeper.properties /opt/kafka_2.11-2.3.1/config/
echo -e "${green} ------------------------kafka success------------------------- ${plain}"
echo --------------------------------------------------------------
}


install_redis(){
echo -e "${yellow} WARNING:starting to install redis?${plain}"
read -p "[yes|no]>>>" myread4
while [[ $myread4 != "yes"&&$myread4 != "no" ]]
 do
  echo -e "${yellow}warning:starting install?${plain}"
  read -p "[yes|no]>>>" myread4
 done
if [ $myread4 == "no" ] ;then
return
fi
cd $ins_dir
echo -e "${green}------------------redis start--------------------------==${plain}"
wget http://download.redis.io/releases/redis-5.0.7.tar.gz
tar -xzf redis-5.0.7.tar.gz
rm /opt/redis -rf
mv redis-5.0.7 redis
mv redis /opt/
rm redis-5.0.7.tar.gz
rm redis -rf
cd /opt/redis
make
cd $ins_dir
echo -e "${green}-------------------redis sucess-------------------------${plain}"

}


install_supervisor(){

echo -e "${yellow} WARNING:starting to install supervisor?${plain}"
read -p "[yes|no]>>>" myread5
while [[ $myread5 != "yes"&&$myread5 != "no" ]]
 do
  echo -e "${yellow}warning:starting install?${plain}"
  read -p "[yes|no]>>>" myread5 
done
if [ $myread5 == "no" ] ;then
return
fi
ps -ef | grep "supervisor" | awk '{print $2}' |xargs kill -9
ps -ef | grep "dlms" | awk '{print $2}' |xargs kill -9
ps -ef | grep "emq" | awk '{print $2}' |xargs kill -9
ps -ef | grep "kafka" | awk '{print $2}' |xargs kill -9
ps -ef | grep "zookeeper" | awk '{print $2}' |xargs kill -9
supervisorjar=$(rpm -qa|grep -i supervisor )
yum remove -y $supervisorjar
#./expects/deletesupervisor.sh 
yum install -y epel-release
yum install -y supervisor
#./expects/install_supervisor.sh
rm /data/supervisor/supervisor.sock
rm /data/supervisor/supervisord.log
rm /data/supervisor/supervisord.pid
rm /etc/supervisord.conf -f
rm /etc/supervisord.d -rf
mv /etc/supervisor  /etc/supervisor-old
rm /etc/supervisor-old -rf
rm /data/supervisor
mkdir /data/supervisor
mkdir /data/supervisor/log

#mkdir /etc/supervisor
#mkdir /etc/supervisor/conf.d

##mkdir /data/supervisor
#mkdir /data/supervisor/log
#fi

touch /data/supervisor/supervisor.sock
chmod 777 /data/supervisor/
unlink /data/supervisor/supervisor.sock





cp ${ins_dir}/supervisor /etc/  -rf
cd $ins_dir
## kaiji qidong 
cp ${ins_dir}/supervisor.service /etc/systemd/system/supervisor.service
chmod 766 /etc/systemd/system/supervisor.service
#chown -R ${cur_user}:${cur_user} /etc/systemd/system/supervisor.service
#sudo touch /data/supervisor/supervisor.sock
#sudo chmod 777 /data/supervisor/supervisor.sock
systemctl enable supervisor.service
systemctl daemon-reload
echo -e "$green supervisor install sucess$plain"
}


install_dlms() {
echo -e "${yellow} WARNING:starting to install dlms?${plain}"
cd $ins_dir
tar -xzf $ins_dir/dlms.tar
rm /opt/org.lowan.java -rf
cp dlms /opt/org.lowan.java -rf
sed -i 's/10.10.0.37/'$ip_addr'/g' /opt/org.lowan.java/dlms.service/conf/service.properties


echo -e "$green dlms success$plain"
}


start_service(){
echo -e "$yellow start service $plain"
systemctl start supervisor
supervisord -c /etc/supervisor/supervisord.conf
}
start_mysql(){
./mysql.sh
}
tuning_guide(){
cd $ins_dir/config/
./tuning.sh

}
finished(){
echo -e "$green -----------------------------------------------------------$plain"
echo -e "$green ||                                                       ||$plain"
echo -e "$green ||                     finished!                         ||$plain"
echo -e "$green ||                                                       ||$plain"
echo -e "$green -----------------------------------------------------------$plain"

}


main(){
install_prepare
install_java
install_emqttd
install_zookeeper_kafka
install_redis
install_supervisor
install_dlms
start_mysql
start_service
tuning_guide
finished
#########
#echo $#
}


main
