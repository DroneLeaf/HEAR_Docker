#!/bin/bash

# $1 = $TARGET_RPI
# $2 =  $TARGET_UBUNTU
# $3 = $TARGET_ORIN
# $4 = /home/$USERNAME/$WS_NAME
# $4 = $USERNAME

echo "╦ ╦╔═╗╔═╗╦═╗    ╔═╗╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠═╣║╣ ╠═╣╠╦╝    ╠╣ ║    ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩ ╩╚═╝╩ ╩╩╚═────╚  ╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

# source ros
source /opt/ros/noetic/setup.bash

# create workspace
mkdir -p $4/src
cd $4/src
git clone -b devel https://github.com/HazemElrefaei/HEAR_FC.git HEAR_FC
cd HEAR_FC && git submodule update --init --recursive

# return to workspace and build
cd $4
catkin_make clean -DTARGET_RPI=$1 -DTARGET_UBUNTU=$2

#RUN bash -c "cd /HEAR_FC &&cp -r /HEAR_FC/mavros_msgs /HEAR_FC/devel/include"
catkin_make clean -DTARGET_RPI=$1 -DTARGET_UBUNTU=$2
catkin_make -DCMAKE_BUILD_TYPE=Debug -DTARGET_RPI=$1 -DTARGET_UBUNTU=$2 -DTARGET_ORIN=$3 -Wno-dev
cd
#RUN touch /home/pi/.bashrc

# source HEAR_FC
# source $4/devel/setup.bash
# echo "source $4/devel/setup.bash" >> /home/$4/.bashrc
# source /home/$4/.bashrc