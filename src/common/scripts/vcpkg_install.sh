#!/bin/bash

echo "╦  ╦╔═╗╔═╗╦╔═╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╚╗╔╝║  ╠═╝╠╩╗║ ╦  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo " ╚╝ ╚═╝╩  ╩ ╩╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

username=$(whoami)
ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt update && sudo  apt -y install build-essential git curl unzip tar zip
sudo apt update && sudo  apt -y install ninja-build

sudo apt-get install autoconf-archive -y


# git clone https://github.com/Microsoft/vcpkg.git /home/$username/vcpkg
git clone --depth 1 --branch 2023.02.24 https://github.com/Microsoft/vcpkg.git /home/$username/vcpkg

cd /home/$username/vcpkg

export VCPKG_FORCE_SYSTEM_BINARIES=1
export VCPKG_FORCE_SYSTEM_BINARIES=1 &&./bootstrap-vcpkg.sh -disableMetrics


 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install linux-headers
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install cpr
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install rapidjson
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Context
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Filesystem
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-System
 cd /home/$username/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Regex