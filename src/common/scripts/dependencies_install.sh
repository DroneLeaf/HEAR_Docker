#!/bin/bash

echo "╔╦╗┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐┌┐┌┌─┐┬┌─┐┌─┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo " ║║├┤ ├─┘├┤ │││ ││├┤ ││││  │├┤ └─┐  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "═╩╝└─┘┴  └─┘┘└┘─┴┘└─┘┘└┘└─┘┴└─┘└─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt-get update && sudo  apt-get install -y gnupg
sudo apt-get upgrade -y

sudo apt-get install libgtk-3-dev -y
sudo apt-get install libgtkmm-3.0-dev -y
sudo apt-get install libgstreamermm-1.0-dev -y


sudo apt-get install libpcap-dev -y

sudo apt-get install python3-opencv -y

sudo apt-get update && \
    sudo apt-get install build-essential libssl-dev -y && \
    sudo apt-get install curl -y


sudo apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential 
sudo apt install python3-rosdep -y
sudo apt install ros-noetic-slam-gmapping -y
sudo apt-get install ros-noetic-mavros* -y
sudo apt-get install -y ros-noetic-tf2-geometry-msgs
sudo apt-get install -y graphviz-dev

## add your dependencies here 👇👇