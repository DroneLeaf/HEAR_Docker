#ARM64

#ARG opencv_url

FROM ubuntu:20.04 AS base
LABEL org.opencontainers.image.title="crosscompiling system" 
LABEL org.opencontainers.image.description="Create prebuilded images for specific platforms" 
LABEL org.opencontainers.image.authors="Ahmed Hashim" 
LABEL org.opencontainers.image.documentation="https://github.com/ahmed-hashim-pro/HEAR_Docker" 
LABEL org.opencontainers.image.version="1.0.0" 
ARG DEBIAN_FRONTEND=noninteractive # ignore user input required
# Install required build dependencies

# All Args
ARG TARGETPLATFORM
ARG ARCHITECTURE
ARG CMAKETtarget

ARG GITHUB_ID
ARG GITHUB_TOKEN

ARG TARGET_RPI
ARG TARGET_UBUNTU

#USER root
ADD /RPi_UbuntuSer20_noWeb /scripts

RUN chmod +x scripts/base.sh
RUN chmod +x scripts/cmake_install.sh
RUN chmod +x scripts/vcpkg_install.sh
RUN chmod +x scripts/opencv_install.sh
RUN chmod +x scripts/ros_install.sh
RUN chmod +x scripts/dependencies_install.sh

RUN ./scripts/base.sh

# cmake

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then\
    ARCHITECTURE=amd64 && CMAKETtarget=x86_64 ;\
  elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
   ARCHITECTURE=arm && CMAKETtarget="aarch64"; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then\
   ARCHITECTURE=aarch64 && CMAKETtarget=aarch64 ;\
  else ARCHITECTURE=amd64;\
  fi;\
  ./scripts/cmake_install.sh $CMAKETtarget

CMD ["bash"]

FROM base AS vcpkg_img
ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone



RUN if [ "$TARGET_UBUNTU" = "ON" ]; then\
    ./scripts/vcpkg_install.sh; \
  fi;


CMD ["bash"]



FROM cyrilix/opencv-runtime:4.8.0 AS opencv_base
CMD ["bash"]

FROM vcpkg_img
RUN cd ~/

RUN sysctl -w kernel.msgmax=65536


RUN echo dpkg -L opencv
COPY --from=opencv_base usr/local  usr/local

#install ros and it's dependencies
RUN ./scripts/ros_install.sh
RUN ./scripts/dependencies_install.sh


RUN mkdir /HEAR_FC
WORKDIR /HEAR_FC
#ADD /mavros_msgs /HEAR_FC/mavros_msgs

# setup git credentials
RUN git config --global user.name "docker image"

RUN git config \
    --global \
    url."https://${GITHUB_ID}:${GITHUB_TOKEN}@github.com/".insteadOf \
    "https://github.com/"


RUN mkdir -p /home/pi/HEAR_FC/src

RUN cd /HEAR_FC/src  &&  git clone -b devel https://github.com/HazemElrefaei/HEAR_FC.git HEAR_FC
RUN cd /HEAR_FC/src/HEAR_FC && git submodule update --init --recursive



RUN apt install -y libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev build-essential bison flex libssl-dev bc
RUN apt install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf

RUN apt-get install -y g++-arm-linux-gnueabihf
RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean -DTARGET_RPI=${TARGET_RPI} -DTARGET_UBUNTU=${TARGET_UBUNTU}'
ARG TARGET_RPI
ARG TARGET_UBUNTU
#RUN bash -c "cd /HEAR_FC &&cp -r /HEAR_FC/mavros_msgs /HEAR_FC/devel/include"
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean -DTARGET_RPI=${TARGET_RPI} -DTARGET_UBUNTU=${TARGET_UBUNTU}'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make -DCMAKE_BUILD_TYPE=Debug -DTARGET_RPI=${TARGET_RPI} -DTARGET_UBUNTU=${TARGET_UBUNTU}  -Wno-dev'

RUN /bin/bash -c "cd /home/pi/HEAR_FC && source /home/pi/HEAR_FC/devel/setup.bash"
ADD entrypoint.sh /
#COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

