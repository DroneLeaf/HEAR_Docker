#ARM64
FROM ubuntu:20.04 AS base
ARG DEBIAN_FRONTEND=noninteractive # ignore user input required
# Install required build dependencies
#USER root
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get -y update && apt-get install -y
RUN apt-get -y install g++  git curl zip pkg-config

# cmake
ARG TARGETPLATFORM
ARG ARCHITECTURE
ARG CMAKETtarget

RUN apt-get update \
  && apt-get -y install build-essential \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then\
    ARCHITECTURE=amd64 && CMAKETtarget="x86_64" ; \
  elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
   ARCHITECTURE=arm && CMAKETtarget="aarch64"; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then\
   ARCHITECTURE=aarch64 && CMAKETtarget="aarch64"; \
  else ARCHITECTURE=amd64;\
  fi;\
  wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-${ARCHITECTURE}.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-3.24.1 \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1 \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin

# end
CMD ["bash"]

FROM base AS vcpkg_img
ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt -y install build-essential git unzip tar zip
RUN apt update && apt -y install ninja-build

RUN git clone https://github.com/Microsoft/vcpkg.git /opt/vcpkg

WORKDIR /opt/vcpkg

#RUN ./bootstrap-vcpkg.sh && ./vcpkg integrate install && ./vcpkg integrate bash && echo 'export PATH=$PATH:/opt/vcpkg' >>~/.bashrc
RUN export VCPKG_FORCE_SYSTEM_BINARIES=1
RUN export VCPKG_FORCE_SYSTEM_BINARIES=1 &&./bootstrap-vcpkg.sh -disableMetrics
# 

WORKDIR /root
#WORKDIR /root
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install cpr
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install rapidjson
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Context
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Filesystem
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-System
RUN  cd /opt/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Regex


#RUN vcpkg install rapidjson
CMD ["bash"]


FROM cyrilix/opencv-runtime:4.8.0 AS opencv-base
CMD ["bash"]

# FROM ubuntu:20.04 AS opencv-base
# ARG DEBIAN_FRONTEND=noninteractive # ignore user input required

# LABEL maintainer="Ahmed_Hashim"

# ENV TZ=Europe/Madrid
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# RUN apt-get update && apt-get install -y --no-install-recommends \
#             tzdata git build-essential cmake pkg-config wget unzip libgtk2.0-dev \
#             curl ca-certificates libcurl4-openssl-dev libssl-dev \
#             libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev \
#             libjpeg-turbo8-dev libpng-dev libtiff-dev libdc1394-22-dev nasm && \
#             rm -rf /var/lib/apt/lists/*

# ARG OPENCV_VERSION="4.8.1"
# ENV OPENCV_VERSION $OPENCV_VERSION

# ARG OPENCV_FILE="https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip"
# ENV OPENCV_FILE $OPENCV_FILE

# ARG OPENCV_CONTRIB_FILE="https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip"
# ENV OPENCV_CONTRIB_FILE $OPENCV_CONTRIB_FILE

# RUN curl -Lo opencv.zip ${OPENCV_FILE} && \
#             unzip -q opencv.zip && \
#             curl -Lo opencv_contrib.zip ${OPENCV_CONTRIB_FILE} && \
#             unzip -q opencv_contrib.zip && \
#             rm opencv.zip opencv_contrib.zip && \
#             cd opencv-${OPENCV_VERSION} && \
#             mkdir build && cd build && \
#             cmake -D CMAKE_BUILD_TYPE=RELEASE \
#                   -D WITH_IPP=OFF \
#                   -D WITH_OPENGL=OFF \
#                   -D WITH_QT=OFF \
#                   -D CMAKE_INSTALL_PREFIX=/usr/local \
#                   -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
#                   -D OPENCV_ENABLE_NONFREE=ON \
#                   -D WITH_JASPER=OFF \
#                   -D WITH_TBB=ON \
#                   -D BUILD_JPEG=ON \
#                   -D WITH_SIMD=ON \
#                   -D ENABLE_LIBJPEG_TURBO_SIMD=ON \
#                   -D BUILD_DOCS=OFF \
#                   -D BUILD_EXAMPLES=OFF \
#                   -D BUILD_TESTS=OFF \
#                   -D BUILD_PERF_TESTS=ON \
#                   -D BUILD_opencv_java=NO \
#                   -D BUILD_opencv_python=NO \
#                   -D BUILD_opencv_python2=NO \
#                   -D BUILD_opencv_python3=NO \
#                   -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
#             make -j $(nproc --all) && \
#             make preinstall && make install && ldconfig && \
#             cd / && rm -rf opencv*

# CMD ["opencv_version", "-b"]





FROM vcpkg_img


RUN cd ~/
#RUN ls
#COPY --from=vcpkg_img opt/vcpkg /root/vcpkg
RUN mkdir -p /root/opencv/build
RUN echo dpkg -L opencv
COPY --from=opencv-base usr/local  usr/local


#RUN git clone https://github.com/microsoft/vcpkg ~/vcpkg \
 #   && cd ~/vcpkg \
  #  && ./bootstrap-vcpkg.sh -useSystemBinaries
#RUN chown -R root:root /root/vcpkg
#RUN chmod -R 777 ~/vcpkg
#RUN cd ~/vcpkg
#WORKDIR ~/vcpkg

#RUN bash -c "~/vcpkg/bootstrap-vcpkg.sh && cd ~/vcpkg"
#RUN bash -c "  cd ~/vcpkg && ./vcpkg integrate install"

#WORKDIR /root/vcpkg
#RUN vcpkg install cpr
#RUN cd ~/vcpkg && ./vcpkg install rapidjson
#RUN ~/vcpkg && ./vcpkg install boost-Context
#RUN ~/vcpkg && ./vcpkg install boost-Filesystem
#RUN ~/vcpkg && ./vcpkg install boost-System
#RUN ~/vcpkg && ./vcpkg install boost-Regex

RUN apt-get install libgtk-3-dev -y
RUN apt-get install libgtkmm-3.0-dev -y
RUN apt-get install libgstreamermm-1.0-dev -y



Run apt-get install libpcap-dev -y

RUN apt-get -y update && apt-get install -y

RUN  echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list
RUN cat  /etc/apt/sources.list.d/ros-latest.list
#RUN touch  /etc/apt/sources.list.d/ros-latest.list
#RUN sed -i '$a\deb http://packages.ros.org/ros/ubuntu focal main' /etc/apt/sources.list.d/ros-latest.list

RUN chmod -R 777 /etc/apt/sources.list.d/ros-latest.list
RUN bash -c  "curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc |  apt-key add -"
#RUN apt-get -y update && apt-get install -y
RUN echo $(cat /etc/apt/sources.list.d/ros-latest.list)
RUN echo $(ls -1 /tmp/dir)
RUN apt-get update
RUN bash -c "apt install ros-noetic-desktop-full -y"
RUN apt-get install python3-opencv -y


RUN apt-get update && \
    apt-get install build-essential libssl-dev -y && \
    apt-get install curl -y

WORKDIR /opt/ros
RUN source /opt/ros/noetic/setup.bash
RUN source "/opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#RUN bash -c " ". /opt/ros/noetic/setup.bash" >> ~/.bashrc"
#SHELL ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash" >> ~/.bashrc"]
#RUN bash -c  "echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc "
RUN source ~/.bashrc
RUN apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y
RUN apt install python3-rosdep
RUN apt install ros-noetic-slam-gmapping -y
RUN apt-get install ros-noetic-mavros* -y
RUN apt-get install -y ros-noetic-tf2-geometry-msgs
RUN apt-get install -y graphviz-dev

RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update


RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
#RUN apt-get install libopencv
#WORKDIR /HEAR_FC
#COPY . .
# Run cmake configure & build process

RUN sysctl -w kernel.msgmax=65536


# TODO : make vcpkg install at root folder not opt folder
COPY --from=vcpkg_img opt/vcpkg /root/vcpkg

RUN mkdir /HEAR_FC
WORKDIR /HEAR_FC
ADD /mavros_msgs /HEAR_FC/mavros_msgs

# setup git credentials
RUN git config --global user.name "docker image"
ARG GITHUB_ID
ARG GITHUB_TOKEN
RUN git config \
    --global \
    url."https://${GITHUB_ID}:${GITHUB_TOKEN}@github.com/".insteadOf \
    "https://github.com/"

RUN mkdir -p /HEAR_FC/src

RUN cd /HEAR_FC/src  &&  git clone -b refactor_templates_no_ros https://github.com/HazemElrefaei/HEAR_FC.git
RUN cd /HEAR_FC/src/HEAR_FC && git submodule update --init --recursive


RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean'

RUN bash -c "cd /HEAR_FC &&cp -r /HEAR_FC/mavros_msgs /HEAR_FC/devel/include"
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make -DCMAKE_BUILD_TYPE=Debug  -Wno-dev'

RUN /bin/bash -c "cd /HEAR_FC && source /HEAR_FC/devel/setup.bash"
ADD entrypoint.sh /
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

