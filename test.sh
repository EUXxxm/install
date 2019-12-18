#!/bin/bash

title "2. ${yellow}Repair locale problem${plain}"
    yum reinstall glibc-common -y
    localedef -v -c -i en_US -f UTF-8 en_US.UTF-8
    find_in_file "LANG=en_US.utf-8" /etc/environment
    if [ $? -ne 0 ]; then
      echo LANG=en_US.utf-8 >> /etc/environment
      echo LC_ALL=en_US.utf-8 >> /etc/environment
    fi
    source /etc/environment
    phase_finished

