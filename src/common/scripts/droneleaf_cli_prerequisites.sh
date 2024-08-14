#!/bin/bash



sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}


sudo dpkg --configure -a
sudo apt-get -y install g++  git curl zip pkg-config gnupg netplan.io wireless-tools jq unzip wget 
sudo apt update && sudo apt install python3 -y && sudo apt install python3-pip -y
sudo apt install python3-pip -y
pip3 install  awscli
sudo apt-get install expect -y
sudo apt-get install net-tools -y
sudo apt-get install tmux -y
sudo apt update -y