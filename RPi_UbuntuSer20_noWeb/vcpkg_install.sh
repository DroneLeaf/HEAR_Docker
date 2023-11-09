#!/bin/bash

echo "╦  ╦╔═╗╔═╗╦╔═╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╚╗╔╝║  ╠═╝╠╩╗║ ╦  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo " ╚╝ ╚═╝╩  ╩ ╩╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";


ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

apt update && apt -y install build-essential git curl unzip tar zip
apt update && apt -y install ninja-build

git clone https://github.com/Microsoft/vcpkg.git ~/vcpkg

cd ~/vcpkg

export VCPKG_FORCE_SYSTEM_BINARIES=1
export VCPKG_FORCE_SYSTEM_BINARIES=1 &&./bootstrap-vcpkg.sh -disableMetrics


 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install cpr
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install rapidjson
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Context
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Filesystem
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-System
 cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Regex