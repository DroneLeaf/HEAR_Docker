#ARM64
FROM ubuntu:20.04 AS base
ARG DEBIAN_FRONTEND=noninteractive # ignore user input required
# Install required build dependencies
#USER root
ADD /RPi_UbuntuSer20_noWeb /scripts

RUN chmod +x scripts/base.sh
RUN chmod +x scripts/cmake_install.sh
RUN chmod +x scripts/vcpkg_install.sh
RUN chmod +x scripts/opencv_install.sh
RUN chmod +x scripts/ros_install.sh

RUN ./scripts/base.sh

# cmake
ARG TARGETPLATFORM
ARG ARCHITECTURE
ARG CMAKETtarget


RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then\
    ARCHITECTURE=amd64 && CMAKETtarget="x86_64" && ./scripts/cmake_install.sh x86_64; \
  elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
   ARCHITECTURE=arm && CMAKETtarget="aarch64"; \
  elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then\
   ARCHITECTURE=aarch64 && CMAKETtarget="aarch64" && ./scripts/cmake_install.sh aarch64; \
  else ARCHITECTURE=amd64;\
  fi;
# end
CMD ["bash"]

FROM base AS vcpkg_img
ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN ./scripts/vcpkg_install.sh

#RUN vcpkg install rapidjson
CMD ["bash"]


FROM cyrilix/opencv-runtime:4.8.0 AS opencv-base
CMD ["bash"]

FROM vcpkg_img
RUN cd ~/

RUN sysctl -w kernel.msgmax=65536

RUN echo dpkg -L opencv
COPY --from=opencv-base usr/local  usr/local

#install ros and it's dependencies
RUN ./scripts/ros_install.sh


RUN mkdir /HEAR_FC
WORKDIR /HEAR_FC
#ADD /mavros_msgs /HEAR_FC/mavros_msgs


# setup git credentials
RUN git config --global user.name "docker image"
ARG GITHUB_ID
ARG GITHUB_TOKEN
RUN git config \
    --global \
    url."https://${GITHUB_ID}:${GITHUB_TOKEN}@github.com/".insteadOf \
    "https://github.com/"

RUN mkdir -p /HEAR_FC/src

RUN cd /HEAR_FC/src  &&  git clone -b devel https://github.com/HazemElrefaei/HEAR_FC.git HEAR_FC
RUN cd /HEAR_FC/src/HEAR_FC && git submodule update --init --recursive


RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean'

#RUN bash -c "cd /HEAR_FC &&cp -r /HEAR_FC/mavros_msgs /HEAR_FC/devel/include"
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make clean'
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; cd /HEAR_FC; catkin_make -DCMAKE_BUILD_TYPE=Debug  -Wno-dev'

RUN /bin/bash -c "cd /HEAR_FC && source /HEAR_FC/devel/setup.bash"
ADD entrypoint.sh /
#COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

