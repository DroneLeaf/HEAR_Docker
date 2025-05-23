#!/bin/bash

echo "╔═╗╔╦╗╔═╗╦╔═╔═╗  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "║  ║║║╠═╣╠╩╗║╣   ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚═╝╩ ╩╩ ╩╩ ╩╚═╝  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

sudo apt-get update \
  && sudo apt-get -y install build-essential \
  && sudo apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

sudo wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-$1.sh \
       -O ~/cmake-install_3.24.1.sh \
      && sudo chmod u+x ~/cmake-install_3.24.1.sh \
      && sudo mkdir -p /opt/cmake-3.24.1 \
      && sudo ~/cmake-install_3.24.1.sh --skip-license --prefix=/opt/cmake-3.24.1 \
      && sudo rm ~/cmake-install_3.24.1.sh \
      && sudo ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin


cmake --version