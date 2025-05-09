#!/bin/bash

echo "╦  ╦╔═╗╔═╗╦╔═╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╚╗╔╝║  ╠═╝╠╩╗║ ╦  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo " ╚╝ ╚═╝╩  ╩ ╩╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}


ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt update && sudo  apt -y install build-essential git curl unzip tar zip
sudo apt update && sudo  apt -y install ninja-build

sudo apt-get install autoconf-archive -y


# git clone https://github.com/Microsoft/vcpkg.git ~/vcpkg
git clone --depth 1 --branch 2023.02.24 https://github.com/Microsoft/vcpkg.git ~/vcpkg

cd ~/vcpkg

export VCPKG_FORCE_SYSTEM_BINARIES=1
export VCPKG_FORCE_SYSTEM_BINARIES=1 &&./bootstrap-vcpkg.sh -disableMetrics


 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install linux-headers
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install cpr
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install rapidjson
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Context
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Filesystem
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-System
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Regex