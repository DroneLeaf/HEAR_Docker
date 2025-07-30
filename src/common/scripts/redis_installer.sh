#!/bin/bash


echo "Installing Redis Server"

# Install Redis server
sudo apt-get install -y redis-server

# Install redis dev tools

echo "Installing Redis development tools"
sudo apt install libhiredis-dev -y

mkdir -p ~/.hear-cli/redis_tmp
cd ~/.hear-cli/redis_tmp

git clone https://github.com/sewenew/redis-plus-plus.git
cd redis-plus-plus
mkdir build && cd build
cmake ..
make
sudo make install
