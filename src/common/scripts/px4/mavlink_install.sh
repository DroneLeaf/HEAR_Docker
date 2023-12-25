#!/bin/bash

echo "╔╦╗╔═╗╦  ╦╦  ┬┌┐┌┬┌─  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "║║║╠═╣╚╗╔╝║  ││││├┴┐  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩ ╩╩ ╩ ╚╝ ╩═╝┴┘└┘┴ ┴  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
    [[ $EUID = 0 ]] || set -- command sudo "$@"
    "$@"
}

apt-get update && apt-get install -y
apt-get upgrade -y

sudo apt-get install build-essential libgeographic-dev -y
sudo apt-get install ros-noetic-mavlink -y
sudo apt-get install ros-noetic-geographic-msgs -y

sudo apt install python3 python3-pip
pip3 install --user future
sudo apt install python3-lxml libxml2-utils
sudo apt install python3-tk

source /opt/ros/noetic/setup.bash


cd
git clone https://github.com/mavlink/mavlink.git --recursive
python3 -m pip install -r ~/mavlink/pymavlink/requirements.txt
PYTHONPATH=~/mavlink

cd ~/mavlink && sudo python3 -m pymavlink.tools.mavgen --lang=C --wire-protocol=2.0 --output=generated/include/mavlink/v2.0 message_definitions/v1.0/common.xml
############
sudo apt install build-essential manpages-dev git automake autoconf 
gcc --version 
sudo apt-get install python3-pip -y
#sudo apt install python-pip -y

pip install future 
sudo apt-get install python-dev libxml2 libxml2-dev libxslt-dev -y
pip3 install lxml 
sudo pip3 install -U future lxml 
sudo apt install xmlto -y

sudo apt-get install python3-matplotlib -y

#sudo apt-get install cmake 

pip install pymavlink 
cd ~/mavlink/pymavlink
sudo python3 setup.py install


