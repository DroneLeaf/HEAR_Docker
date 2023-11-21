#ARM64

ARG opencv_url

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

# RUN chmod +x scripts/base.sh
# RUN chmod +x scripts/cmake_install.sh
# RUN chmod +x scripts/vcpkg_install.sh
# RUN chmod +x scripts/opencv_install.sh
# RUN chmod +x scripts/ros_install.sh
# RUN chmod +x scripts/mavros_install.sh
# RUN chmod +x scripts/mavlink_install.sh
# RUN chmod +x scripts/dependencies_install.sh
# RUN chmod +x scripts/hear_fc_install.sh
ADD /RPi_UbuntuSer20_noWeb/base.sh /scripts/base.sh
RUN chmod +x scripts/base.sh
RUN ./scripts/base.sh

# cmake
ADD /RPi_UbuntuSer20_noWeb/cmake_install.sh /scripts/cmake_install.sh
RUN chmod +x scripts/cmake_install.sh
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


ADD /RPi_UbuntuSer20_noWeb/vcpkg_install.sh /scripts/vcpkg_install.sh
RUN chmod +x scripts/vcpkg_install.sh
RUN if [ "$TARGET_UBUNTU" = "ON" ]; then\
    ./scripts/vcpkg_install.sh; \
  fi;

CMD ["bash"]


#cyrilix/opencv-runtime:4.8.0
# Make opencv image url as an arg so we can throw real opencv url
# to activate opencv install only for specific targets or throw base stage name to install nothing and avoid errors
FROM $opencv_url AS opencv_base
CMD ["bash"]

FROM vcpkg_img
RUN cd ~/

# We have to update ipc msgmax so we can receive onnx data and for activate ipc on ubntu image
RUN sysctl -w kernel.msgmax=65536

RUN echo dpkg -L opencv
COPY --from=opencv_base usr/local  usr/local

#install ros and it's dependencies
ADD /RPi_UbuntuSer20_noWeb/ros_install.sh /scripts/ros_install.sh
RUN chmod +x scripts/ros_install.sh
RUN ./scripts/ros_install.sh

ADD /RPi_UbuntuSer20_noWeb/dependencies_install.sh /scripts/dependencies_install.sh
RUN chmod +x scripts/dependencies_install.sh
RUN ./scripts/dependencies_install.sh

ADD /RPi_UbuntuSer20_noWeb/mavros_install.sh /scripts/mavros_install.sh
RUN chmod +x scripts/mavros_install.sh
RUN ./scripts/mavros_install.sh


ADD /RPi_UbuntuSer20_noWeb/mavlink_install.sh /scripts/mavlink_install.sh
RUN chmod +x scripts/mavlink_install.sh
RUN ./scripts/mavlink_install.sh


ARG USERNAME
ARG WS_NAME

# #RUN useradd -p "" -ms /bin/bash $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && adduser $USERNAME sudo
# RUN useradd -ms /bin/bash $USERNAME && \
#     usermod -aG sudo $USERNAME
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER $USERNAME

#RUN chown -R   /scripts
#RUN chmod +x /scripts
#RUN chgrp -R $USERNAME /scripts


RUN mkdir -p /home/$USERNAME/$WS_NAME
WORKDIR /home/$USERNAME/$WS_NAME

# setup git credentials
RUN git config --global user.name "docker image"

RUN git config \
    --global \
    url."https://${GITHUB_ID}:${GITHUB_TOKEN}@github.com/".insteadOf \
    "https://github.com/"

#RUN mkdir -p /HEAR_FC/src

# RUN cd /HEAR_FC/src  &&  git clone -b devel https://github.com/HazemElrefaei/HEAR_FC.git HEAR_FC
# RUN cd /HEAR_FC/src/HEAR_FC && git submodule update --init --recursive

ARG TARGET_RPI
ARG TARGET_UBUNTU

RUN mkdir -p /home/$USERNAME/scripts

RUN touch /home/$USERNAME/.bashrc

ADD /RPi_UbuntuSer20_noWeb/hear_fc_install.sh /home/$USERNAME/scripts/hear_fc_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_fc_install.sh
RUN cd /home/$USERNAME/scripts && ./hear_fc_install.sh $TARGET_RPI $TARGET_UBUNTU /home/$USERNAME/$WS_NAME $USERNAME

# RUN bash -c "source /opt/ros/noetic/setup.bash"
# RUN bash -c "echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc"
# RUN bash -c "source /home/$USERNAME/.bashrc"

# RUN bash -c "source /home/$USERNAME/$WS_NAME/devel/setup.bash"
# RUN bash -c "echo "source /home/$USERNAME/$WS_NAME/devel/setup.bash" >> /home/$USERNAME/.bashrc"
# RUN bash -c "source /home/$USERNAME/.bashrc"

ADD entrypoint.sh /
#COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

