#!/bin/bash
 
# Source ROS and Catkin workspaces
source /opt/ros/noetic/setup.bash
# sudo echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
# source ~/.bashrc
#source ~/catkin_ws/devel/setup.bash
source $1/devel/setup.bash
# sudo echo "source $1/devel/setup.bash" >> ~/.bashrc
# source ~/.bashrc
# if [ -f $2/devel/setup.bash ]
# then
#   source $2/devel/setup.bash
# fi

echo "start Catkin workspace!"
#roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV
 
# Set environment variables
#export TURTLEBOT3_MODEL=waffle_pi
#export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(rospack find tb3_worlds)/models
# if [-n "$@" ]
# then
# exec "$@"
# else
# roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV
# fi
echo "$2"
$2
# Execute the command passed into this entrypoint
