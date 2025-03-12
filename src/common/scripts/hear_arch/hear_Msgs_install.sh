#!/bin/bash

# $1 = $TARGET_RPI
# $2 =  $TARGET_UBUNTU
# $3 = $TARGET_ORIN
# $2 = $WS_NAME
# $5 = $USERNAME
# $6 = $GITHUB_ID
# $7 = $GITHUB_TOKEN

#echo "╦ ╦╔═╗╔═╗╦═╗    ╔═╗╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
#echo "╠═╣║╣ ╠═╣╠╦╝    ╠╣ ║    ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
#echo "╩ ╩╚═╝╩ ╩╩╚═────╚  ╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";


# source ros
source /opt/ros/noetic/setup.bash

branch="main"
# check if a specific branch is provided
if [ -n "$3" ]; then
    branch=$3
fi

# create workspace
echo $2
sudo rm -rf $2
mkdir -p $2/src
cd $2/src

git clone -b $branch --recursive https://github.com/DroneLeaf/HEAR_Msgs.git

cd HEAR_Msgs && git submodule update --init --recursive


cd $2
catkin_make clean
catkin_make clean
catkin_make
echo "source $2/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

cd 
#Source HEAR_Msgs
# cd ~/HEAR_Msgs && source d?evel/setup.bash

#RUN touch /home/pi/.bashrc

# source HEAR_FC
# source $2/devel/setup.bash
# echo "source $2/devel/setup.bash" >> /home/$2/.bashrc
# source /home/$2/.bashrc