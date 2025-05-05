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
git clone -b $7 https://github.com/DroneLeaf/HEAR_FC.git HEAR_FC
cd HEAR_FC && git submodule update --init --recursive
# git clone https://github.com/DroneLeaf/HEAR_Msgs.git 

# return to workspace and build
cd $4
catkin_make clean -DHEAR_TARGET=$6 


#RUN bash -c "cd /HEAR_FC &&cp -r /HEAR_FC/mavros_msgs /HEAR_FC/devel/include"
catkin_make clean -DHEAR_TARGET=$6
catkin_make -DCMAKE_BUILD_TYPE=Debug -DHEAR_TARGET=$6 -Wno-dev
cd
#RUN touch /home/pi/.bashrc

# source HEAR_FC
# source $4/devel/setup.bash
# echo "source $4/devel/setup.bash" >> /home/$4/.bashrc
# source /home/$4/.bashrc