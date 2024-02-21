#!/bin/bash

echo "╦═╗╔═╗╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╦╝║ ║╚═╗  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩╚═╚═╝╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt-get update && apt-get install -y gnupg
sudo apt-get upgrade -y

sudo apt-get install  -y lsb-release


sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-get install curl  -y

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc |  apt-key add -
sudo apt-get update -y

sudo apt install ros-noetic-desktop-full  -y
source /opt/ros/noetic/setup.bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

sudo apt install python3-rosdep -y
sudo rosdep init \
 && rosdep fix-permissions \
 && rosdep update