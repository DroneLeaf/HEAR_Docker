#!/bin/bash

# $1 = $USERNAME

echo "╦ ╦╔═╗╔═╗╦═╗    ╔═╗┌─┐┌┐┌┌─┐┬┌─┐┬ ┬┬─┐┌─┐┌┬┐┬┌─┐┌┐┌┌─┐  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "╠═╣║╣ ╠═╣╠╦╝    ║  │ ││││├┤ ││ ┬│ │├┬┘├─┤ │ ││ ││││└─┐  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╩ ╩╚═╝╩ ╩╩╚═────╚═╝└─┘┘└┘└  ┴└─┘└─┘┴└─┴ ┴ ┴ ┴└─┘┘└┘└─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone 


cd
git clone -b main https://github.com/DroneLeaf/HEAR_Configurations.git
