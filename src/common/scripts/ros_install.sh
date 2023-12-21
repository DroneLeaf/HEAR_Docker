#!/bin/bash

echo "╦═╗╔═╗╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╦╝║ ║╚═╗  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩╚═╚═╝╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

apt-get update && apt-get install -y gnupg
apt-get upgrade -y

apt-get install  -y lsb-release


sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
apt-get install curl  -y

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc |  apt-key add -
apt-get update -y

apt install ros-noetic-desktop-full  -y
source /opt/ros/noetic/setup.bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

apt install python3-rosdep -y
rosdep init \
 && rosdep fix-permissions \
 && rosdep update