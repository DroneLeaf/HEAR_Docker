#!/bin/bash

echo "╔═╗╔═╗╔═╗╔╗╔╔═╗╦  ╦  ╦┌┐┌┌─┐┌┬┐┌─┐┬  ┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ┌─┐┌┬┐┌─┐┬─┐┌┬┐  ";
echo "║ ║╠═╝║╣ ║║║║  ╚╗╔╝  ║│││└─┐ │ ├─┤│  │  ├─┤ │ ││ ││││  └─┐ │ ├─┤├┬┘ │   ";
echo "╚═╝╩  ╚═╝╝╚╝╚═╝ ╚╝   ╩┘└┘└─┘ ┴ ┴ ┴┴─┘┴─┘┴ ┴ ┴ ┴└─┘┘└┘  └─┘ ┴ ┴ ┴┴└─ ┴   ";

sudo ()
{
[[ $EUID = 0 ]] || set -- command sudo "$@"
"$@"
}

ln -snf /usr/share/zoneinfo/Africa/Cairo /etc/localtime && echo Africa/Cairo > /etc/timezone

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
            tzdata git build-essential cmake pkg-config wget unzip libgtk2.0-dev \
            curl ca-certificates libcurl4-openssl-dev libssl-dev \
            libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev \
            libjpeg-turbo8-dev libpng-dev libtiff-dev libdc1394-22-dev nasm && \
            rm -rf /var/lib/apt/lists/*


curl -Lo opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip && \
            unzip -q opencv.zip && \
            curl -Lo opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip && \
            unzip -q opencv_contrib.zip && \
            rm opencv.zip opencv_contrib.zip && \
            cd opencv-4.0.0 && \
            mkdir build && cd build && \
            cmake -D CMAKE_BUILD_TYPE=RELEASE \
                  -D WITH_IPP=OFF \
                  -D WITH_OPENGL=OFF \
                  -D WITH_QT=OFF \
                  -D CMAKE_INSTALL_PREFIX=/usr/local \
                  -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.0.0/modules \
                  -D OPENCV_ENABLE_NONFREE=ON \
                  -D WITH_JASPER=OFF \
                  -D WITH_TBB=ON \
                  -D BUILD_JPEG=ON \
                  -D WITH_SIMD=ON \
                  -D ENABLE_LIBJPEG_TURBO_SIMD=ON \
                  -D BUILD_DOCS=OFF \
                  -D BUILD_EXAMPLES=OFF \
                  -D BUILD_TESTS=OFF \
                  -D BUILD_PERF_TESTS=ON \
                  -D BUILD_opencv_java=NO \
                  -D BUILD_opencv_python=NO \
                  -D BUILD_opencv_python2=NO \
                  -D BUILD_opencv_python3=NO \
                  -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
            make -j $(nproc --all) && \
            make preinstall && make install && ldconfig && \
            cd / && rm -rf opencv*