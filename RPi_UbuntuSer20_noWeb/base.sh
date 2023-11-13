#!/bin/bash


echo "╔╗ ┌─┐┌─┐┌─┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠╩╗├─┤└─┐├┤   ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚═╝┴ ┴└─┘└─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

apt-get -y update && apt-get -y upgrade  && apt-get install -y tcl
apt-get -y install g++  git curl zip pkg-config gnupg

