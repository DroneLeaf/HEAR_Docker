#!/bin/bash

echo "╦═╗╔═╗╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╦╝║ ║╚═╗  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩╚═╚═╝╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

apt update && apt install -y


apt install  -y lsb-release

sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt install curl 

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
apt update
apt install ros-noetic-desktop-full  -y
source /opt/ros/noetic/setup.bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

apt install python3-rosdep -y
rosdep init \
 && rosdep fix-permissions \
 && rosdep update


apt-get install libgtk-3-dev -y
apt-get install libgtkmm-3.0-dev -y
apt-get install libgstreamermm-1.0-dev -y


apt-get install libpcap-dev -y

apt-get install python3-opencv -y

apt-get update && \
    apt-get install build-essential libssl-dev -y && \
    apt-get install curl -y


apt install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential 
apt install python3-rosdep -y
apt install ros-noetic-slam-gmapping -y
apt-get install ros-noetic-mavros* -y
apt-get install -y ros-noetic-tf2-geometry-msgs
apt-get install -y graphviz-dev