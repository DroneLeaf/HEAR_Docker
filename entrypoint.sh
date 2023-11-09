#!/bin/bash
 
# Source ROS and Catkin workspaces
source /opt/ros/noetic/setup.bash
if [ -f /HEAR_FC/devel/setup.bash ]
then
  source /HEAR_FC/devel/setup.bash
fi

echo "start Catkin workspace!"
#roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV
 
# Set environment variables
#export TURTLEBOT3_MODEL=waffle_pi
#export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(rospack find tb3_worlds)/models
if [-n "$@" ]
then
exec "$@"
else
roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV
fi
# Execute the command passed into this entrypoint
