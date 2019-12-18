#!/bin/bash
sudo yum install zsh -y
sudo yum install git -y

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

cp ~/.zshrc ~/.zshrc.bak

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

chsh -s /bin/zsh
