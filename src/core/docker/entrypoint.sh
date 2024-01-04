#!/bin/bash

# Source mavlink
 if [ -f ~/catkin_ws/devel/setup.bash ]
then
  source ~/catkin_ws/devel/setup.bash
fi

# Source ROS and Catkin workspaces
source /opt/ros/noetic/setup.bash

# Source workspace 
source $1/devel/setup.bash

# Source QT 
if [ -d "/opt/Qt5.15/bin" ]
then
  export PATH=/opt/Qt5.15/bin:$PATH
  echo $(qmake --version)
fi

echo "start Running Docker Workspace!"
 
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
