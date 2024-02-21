#!/bin/bash

echo "╔═╗ ┌─┐┬─┐┌─┐┬ ┬┌┐┌┌┬┐┌─┐┌─┐┌┐┌┬┐┬─┐┌─┐┬    ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "║═╬╗│ ┬├┬┘│ ││ ││││ │││  │ │││││ ├┬┘│ ││    ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚═╝╚└─┘┴└─└─┘└─┘┘└┘─┴┘└─┘└─┘┘└┘┴ ┴└─└─┘┴─┘  ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

sudo apt-get update && \
    sudo apt-get install build-essential libssl-dev -y

sudo apt-get install -y --no-install-recommends git wget lcov unzip ca-certificates python 
sudo apt-get install -y python3-pip pkg-config build-essential gperf bison flex libgl1-mesa-dev 
sudo apt-get install -y libglu1-mesa-dev libfontconfig1-dev libdbus-1-dev libfreetype6-dev 
sudo apt-get install -y libicu-dev libinput-dev libxkbcommon-dev libsqlite3-dev libssl-dev 
# apt-get install -y libpng-dev libjpeg-dev libglib2.0-dev libpq-dev libmariadb-dev libmariadbclient-dev 
sudo apt-get install -y libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev 
sudo apt-get install -y libxkbcommon-x11-dev libxcb-xfixes0-dev libxcb-xfixes0 libgpiod-dev


wget -nv http://download.qt.io/official_releases/qt/5.15/5.15.2/single/qt-everywhere-src-5.15.2.tar.xz
tar -xf qt-everywhere-src-5.15.2.tar.xz > /dev/null
rm qt-everywhere-src-5.15.2.tar.xz
wget -nv https://codereview.qt-project.org/changes/qt%2Fqtbase~320610/revisions/2/patch?zip -O patch.zip
unzip patch.zip
patch -f qt-everywhere-src-5.15.2/qtbase/src/network/access/qnetworkreplyhttpimpl.cpp 0807f16.diff
rm patch.zip 0807f16.diff
mkdir build
cd build
../qt-everywhere-src-5.15.2/configure -v -static -opensource -confirm-license -release -reduce-exports -skip qtwebengine -no-feature-geoservices_mapboxgl -qt-pcre -no-pch -evdev -system-freetype -fontconfig -glib -qpa eglfs -nomake examples -no-compile-examples -ssl -prefix /opt/Qt5.15
make -j$(nproc)
make install
cd ..
rm -rf build/
rm -rf qt-everywhere-src-5.15.2