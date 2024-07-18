#!/bin/bash

# https://patorjk.com/software/taag/#p=display&h=2&c=echo&f=Calvin%20S&t=Installation%20start%20

echo "╔═╗┬ ┬┬  ┬    ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╣ │ ││  │    └─┐└┬┘└─┐ │ ├┤ │││  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚  └─┘┴─┘┴─┘  └─┘ ┴ └─┘ ┴ └─┘┴ ┴  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";



chmod +x ../../../src/common/scripts/base.sh
chmod +x ../../../src/common/scripts/cmake_install.sh
chmod +x ../../../src/common/scripts/vcpkg_install.sh
# chmod +x ../../../src/common/scripts/opencv_install.sh
chmod +x ../../../src/common/scripts/ros_install.sh
chmod +x ../../../src/common/scripts/dependencies_install.sh
chmod +x ../../../src/common/scripts/px4/mavros_install.sh
chmod +x ../../../src/common/scripts/px4/netplan-init-eth-netcfg.sh

../../../src/common/scripts/base.sh
../../../src/common/scripts/cmake_install.sh aarch64

../../../src/common/scripts/vcpkg_install.sh
# ../../../src/common/scripts/opencv_install.sh
../../../src/common/scripts/ros_install.sh
../../../src/common/scripts/dependencies_install.sh
../../../src/common/scripts/px4/mavros_install.sh
../../../src/common/scripts/px4/netplan-init-eth-netcfg.sh