#!/bin/bash

echo "╔╦╗┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐┌┐┌┌─┐┬┌─┐┌─┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo " ║║├┤ ├─┘├┤ │││ ││├┤ ││││  │├┤ └─┐  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "═╩╝└─┘┴  └─┘┘└┘─┴┘└─┘┘└┘└─┘┴└─┘└─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

apt-get update && apt-get install -y gnupg
apt-get upgrade -y

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

## add your dependencies here 👇👇