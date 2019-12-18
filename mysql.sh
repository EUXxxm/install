#f

!/bin/bash


red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'


[[ $EUID -ne 0 ]] && echo -e "[${red}Error${plain}] This script must be run as root!" && exit 1


###############################################################################
echo -e "${yellow}WARNING: all of user data will be removed, install mysql?${plain}"
  read -p "[ yes | no ] >>> " gotit
  while [[ "x"$gotit != "xyes" && "x"$gotit != "xno" ]]
    do
      read -p "[ yes | no ] >>> " gotit
    done
if [ ${gotit} == "no" ]; then
 echo OK
 exit 1
fi
###############################################################################

ins_dir=$(cd $(dirname $0);pwd)


delete_mysql_mariadb(){
service mysql stop
mariadbjar=$(rpm -qa |grep mariadb -i)
mysqljar=$(rpm -qa|grep mysql -i)
echo -e "$yellow it's mariadb$plain"
echo $mariadbjar
echo -e "$yellow it's mysql$plain"
echo $mysqljar
echo "___________________"
if [[ $mariadbjar != ""  ]] ; then
yum remove -y $mariadbjar  
fi
if [[ $mysqljar != ""  ]] ; then
yum remove -y $mysqljar 
fi
rm /usr/local/mysql -rf
rm /data/mysql -rf
rm /etc/my.cnf
rm /data/mysql/mysql.err
rm /opt/mysql -rf

## find delite
}

install_mysql5_7_24(){


echo  -e "${yellow}warning:mysql5.7.24 install${plain}"
cd $ins_dir
#download  tar && mv->/user/local/
#wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz
yum install libaio* -y
yum -y install numactl
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz
tar -xzf mysql-5.7.24-linux-glibc2.12-x86_64.tar.gz
mv mysql-5.7.24-linux-glibc2.12-x86_64 /opt/mysql

#add group mysql
groupadd mysql
useradd -r -g mysql mysql
mkdir /opt/mysql/data

#create my.cnf->/etc/
cp my.cnf  /etc/

#initialize mysql
cd /opt/mysql/bin/
./mysqld --defaults-file=/etc/my.cnf --basedir=/opt/mysql/ --datadir=/data/mysql/ --user=mysql --initialize
var=$(cat /data/mysql/mysql.err |grep 'temporary password')
tempassword=${var:0-12:12}

#cat /data/mysql/mysql.err

#move mysql.server to /etc/init.d/mysql 
cp /opt/mysql/support-files/mysql.server /etc/init.d/mysql
#run mysql
service mysql start
rm /usr/bin/mysql -f
ln -s /opt/mysql/bin/mysql /usr/bin
echo -e "$green success:mysql service$plain"
#echo -e "$yellow please reset mysql password ,the temporary password available with the order :
#	cat /data/mysql/mysql.err |grep 'temporary password'
#	or cat /data/mysql/mysql.err$plain"

$ins_dir/expects/setmysql.sh $tempassword

service mysql restart
echo -e "$green mysql :the password has been reset and  remote access rights added$plain"

}
main() {
delete_mysql_mariadb
install_mysql5_7_24
}
main
