#!/bin/bash

# https://patorjk.com/software/taag/#p=display&h=2&c=echo&f=Calvin%20S&t=Installation%20start%20

echo "╔═╗┬ ┬┬  ┬    ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╣ │ ││  │    └─┐└┬┘└─┐ │ ├┤ │││  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚  └─┘┴─┘┴─┘  └─┘ ┴ └─┘ ┴ └─┘┴ ┴  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

send_status() {

  echo "-----------------STATUS----------------------"
  echo "----------------------------------------"
#   echo "$@"
  echo "$1" >> ~/.hear-cli/$2/status.txt

  echo -e "\033[32m "$1" \033[0m IN fULL SYSTEM INSTALLATION" 1>&2

  echo "----------------------------------------"
  echo "-----------------STATUS----------------------"


}

chmod +x ../../../src/common/scripts/extend_sudo_timeout.sh
chmod +x ../../../src/common/scripts/runtime/source_ros.sh
chmod +x ../../../src/common/scripts/ssh_connection_timeout_changer.sh


chmod +x ../../../src/common/scripts/base.sh
chmod +x ../../../src/common/scripts/cmake_install.sh
chmod +x ../../../src/common/scripts/vcpkg_install.sh
chmod +x ../../../src/common/scripts/opencv_install.sh
# chmod +x ../../../src/common/scripts/ros_install.sh
chmod +x ../../../src/common/scripts/ros/ros_install_ubuntu_20.04.sh

chmod +x ../../../src/common/scripts/dependencies_install.sh
chmod +x ../../../src/common/scripts/px4/mavros_install.sh
chmod +x ../../../src/common/scripts/px4/mavlink_install.sh
chmod +x ../../../src/common/scripts/Qgroundcontrol_install.sh
chmod +x ../../../src/common/scripts/netplan-init-eth-netcfg.sh
chmod +x ../../../src/common/scripts/droneleaf_cli_prerequisites.sh
chmod +x ../../../src/common/scripts/redis_installer.sh


sudo ../../../src/common/scripts/extend_sudo_timeout.sh
send_status "extend_sudo_timeout Success" $1

sudo ../../../src/common/scripts/ssh_connection_timeout_changer.sh
send_status "ssh_connection_timeout_changer Success" $1

../../../src/common/scripts/runtime/source_ros.sh
send_status "source_ros Success" $1

../../../src/common/scripts/base.sh
send_status "Base installation Success" $1

../../../src/common/scripts/cmake_install.sh aarch64
send_status "cmake_install Success" $1

../../../src/common/scripts/vcpkg_install.sh
send_status "vcpkg_install Success" $1

../../../src/common/scripts/opencv_install.sh
send_status "opencv_install Success" $1

../../../src/common/scripts/ros/ros_install_ubuntu_20.04.sh
send_status "ros_install_ubuntu_20.04 Success" $1

../../../src/common/scripts/dependencies_install.sh
send_status "dependencies_install Success" $1

../../../src/common/scripts/px4/mavros_install.sh
send_status "mavros_install Success" $1

../../../src/common/scripts/px4/mavlink_install.sh
send_status "mavlink_install Success" $1

# ../../../src/common/scripts/Qgroundcontrol_install.sh
# send_status "Qgroundcontrol_install Success"

../../../src/common/scripts/netplan-init-eth-netcfg.sh
send_status "netplan-init-eth-netcfg Success" $1

../../../src/common/scripts/droneleaf_cli_prerequisites.sh
send_status "droneleaf_cli_prerequisites Success" $1

../../../src/common/scripts/redis_installer.sh
send_status "redis_installer Success" $1