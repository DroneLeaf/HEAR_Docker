#!/bin/bash


echo "╔╗ ┌─┐┌─┐┌─┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╩╗├─┤└─┐├┤   ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚═╝┴ ┴└─┘└─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt-get -y upgrade && sudo apt-get -y update && sudo apt-get install -y tcl
sudo apt-get -y install g++  git curl zip pkg-config gnupg netplan.io wireless-tools jq unzip wget 
sudo apt update && sudo apt install python3 -y && sudo apt install python3-pip -y
