#!/bin/bash

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

sudo apt-get install -y \
        git wget autoconf automake nano \
        libeigen3-dev libboost-all-dev libsuitesparse-dev \
        doxygen libopencv-dev \
        libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev


    
sudo apt-get install -y python3-dev python3-pip python3-scipy \
        python3-matplotlib ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx    

mkdir -p ~/kalibr_workspace/src
cd ~/kalibr_workspace
export ROS1_DISTRO=noetic # kinetic=16.04, melodic=18.04, noetic=20.04
source /opt/ros/$ROS1_DISTRO/setup.bash
catkin init
catkin config --extend /opt/ros/$ROS1_DISTRO
catkin config --merge-devel # Necessary for catkin_tools >= 0.4.
catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release
cd ~/kalibr_workspace/src
git clone https://github.com/ethz-asl/kalibr.git
cd ~/kalibr_workspace/
catkin build -DCMAKE_BUILD_TYPE=Release -j4


mkdir -p ~/allan_variance_workspace/src
cd ~/allan_variance_workspace/src
git clone https://github.com/ori-drs/allan_variance_ros.git
cd ~/allan_variance_workspace
catkin build allan_variance_ros

sudo apt-get install ros-noetic-realsense2-camera

git clone https://github.com/mvp/uhubctl.git
cd uhubctl
make
make install