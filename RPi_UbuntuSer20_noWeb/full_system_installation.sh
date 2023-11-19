#!/bin/bash

# https://patorjk.com/software/taag/#p=display&h=2&c=echo&f=Calvin%20S&t=Installation%20start%20

echo "╔═╗┬ ┬┬  ┬    ┌─┐┬ ┬┌─┐┌┬┐┌─┐┌┬┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╣ │ ││  │    └─┐└┬┘└─┐ │ ├┤ │││  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚  └─┘┴─┘┴─┘  └─┘ ┴ └─┘ ┴ └─┘┴ ┴  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";



chmod +x base.sh
chmod +x cmake_install.sh
chmod +x vcpkg_install.sh
chmod +x opencv_install.sh
chmod +x ros_install.sh
chmod +x dependencies_install.sh

./base.sh
./cmake_install.sh aarch64

./vcpkg_install.sh
./opencv_install.sh
./ros_install.sh
./dependencies_install.sh