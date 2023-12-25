#ARM64

ARG opencv_url=base

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

ARG TARGET_RPI=OFF
ARG TARGET_UBUNTU=OFF
ARG TARGET_ORIN=OFF


#USER root

ADD /src/common/scripts/base.sh /scripts/base.sh
RUN chmod +x scripts/base.sh
RUN ./scripts/base.sh

# cmake
ADD /src/common/scripts/cmake_install.sh /scripts/cmake_install.sh
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


ADD /src/common/scripts/vcpkg_install.sh /scripts/vcpkg_install.sh
RUN chmod +x scripts/vcpkg_install.sh
# RUN if [ "$TARGET_UBUNTU" = "ON" ]; then\
#     ./scripts/vcpkg_install.sh; \
#   fi;
RUN ./scripts/vcpkg_install.sh

CMD ["bash"]


#cyrilix/opencv-runtime:4.8.0
# Make opencv image url as an arg so we can throw real opencv url
# to activate opencv install only for specific targets or throw base stage name to install nothing and avoid errors
FROM $opencv_url AS opencv_base
CMD ["bash"]

FROM ahmedhashimpro/hashim-ros AS ros_base
CMD ["bash"]

FROM vcpkg_img
ARG DEBIAN_FRONTEND=noninteractive
RUN cd ~/

# We have to update ipc msgmax so we can receive onnx data and for activate ipc on ubntu image
RUN sysctl -w kernel.msgmax=65536

RUN echo dpkg -L opencv
COPY --from=opencv_base usr/local  usr/local
COPY --from=ros_base /opt/ros  /opt/ros
COPY --from=ros_base /usr/bin  /usr/bin

RUN apt-get -y install keyboard-configuration
#install ros and it's dependencies
# ADD /src/common/scripts/ros_install.sh /scripts/ros_install.sh
# RUN chmod +x scripts/ros_install.sh
# RUN ./scripts/ros_install.sh

ADD /src/common/scripts/dependencies_install.sh /scripts/dependencies_install.sh
RUN chmod +x scripts/dependencies_install.sh
RUN ./scripts/dependencies_install.sh

ADD /src/common/scripts/px4/mavros_install.sh /scripts/mavros_install.sh
RUN chmod +x scripts/mavros_install.sh
RUN ./scripts/mavros_install.sh

RUN apt-get update && apt-get install -y python3 python3-distutils python3-pip python3-apt

ADD /src/common/scripts/px4/mavlink_install.sh /scripts/mavlink_install.sh
RUN chmod +x scripts/mavlink_install.sh
RUN ./scripts/mavlink_install.sh


### All Sections variance here

####################### 1️⃣ RPI_UBUNTU20  ########################
# 1. RPI_UBUNTU20 Section Start

# #### add and expose sh files👇👇


# #### target condition execute
RUN if [ "$TARGET_RPI" = "ON" ]; then\
     # run your sh file here 👇👇
     #./scripts/Qgroundcontrol_install.sh; \
     echo "TARGET_RPI Applied";\
    #
  fi;

####################### 👌 END Target 👌 ######################## 

####################### 2️⃣ SITL_UBUNTU20  #######################
# 2. SITL_UBUNTU20 Section Start

# #### add and expose sh files👇👇


# #### target condition execute
RUN if [ "$TARGET_SITL" = "ON" ]; then\
     # run your sh file here 👇👇
     #./scripts/Qgroundcontrol_install.sh; \
     echo "TARGET_SITL Applied";\
    #
  fi;

####################### 👌 END Target 👌 ######################## 

####################### 3️⃣ ORIN_UBUNTU20  #######################
# 3. ORIN_UBUNTU20 Section Start

# #### add and expose sh files
ADD /src/common/scripts/Qgroundcontrol_install.sh /scripts/Qgroundcontrol_install.sh
RUN chmod +x scripts/Qgroundcontrol_install.sh

# #### target condition execute
RUN if [ "$TARGET_ORIN" = "ON" ]; then\
     # run your sh file here 👇👇
    ./scripts/Qgroundcontrol_install.sh; \
    echo "TARGET_ORIN Applied";\
    #
  fi;

####################### 👌 END Target 👌 ######################## 




ARG USERNAME
ARG WS_NAME
ARG TARGET_RPI=OFF
ARG TARGET_UBUNTU=OFF
ARG TARGET_ORIN=OFF
# #RUN useradd -p "" -ms /bin/bash $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && adduser $USERNAME sudo
# RUN useradd -ms /bin/bash $USERNAME && \
#     usermod -aG sudo $USERNAME
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER $USERNAME

#RUN chown -R   /scripts
#RUN chmod +x /scripts
#RUN chgrp -R $USERNAME /scripts

ARG GITHUB_ID
ARG GITHUB_TOKEN

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

# ARG TARGET_RPI
# ARG TARGET_UBUNTU

RUN echo "$TARGET_ORIN TARGET_ORIN2 sadsadsaadl kdjsadj sadjasl"
RUN echo "$TARGET_UBUNTU TARGET_UBUNTU2 sadsadsaadl kdjsadj sadjasl"
RUN echo "$TARGET_RPI TARGET_RPI2 sadsadsaadl kdjsadj sadjasl"

RUN mkdir -p /home/$USERNAME/scripts

RUN touch /home/$USERNAME/.bashrc
COPY --from=ros_base /usr/include  /usr/include
COPY --from=ros_base /usr/lib  /usr/lib 
# COPY --from=ros_base /usr/local  /usr/local
# COPY --from=ros_base /usr/sbin  /usr/sbin
COPY --from=ros_base /usr/share  /usr/share

ADD /src/common/scripts/hear_arch/hear_fc_install.sh /home/$USERNAME/scripts/hear_fc_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_fc_install.sh
RUN if [ "$WS_NAME" = "HEAR_FC" ]; then\
    #
    cd /home/$USERNAME/scripts && ./hear_fc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME; \
    #
  fi;
# RUN cd /home/$USERNAME/scripts && ./hear_fc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME


ADD /src/common/scripts/hear_arch/hear_mc_install.sh /home/$USERNAME/scripts/hear_mc_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_mc_install.sh
RUN if [ "$WS_NAME" = "HEAR_MC" ]; then\
    #
    cd /home/$USERNAME/scripts && ./hear_mc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME; \
    #
  fi;
# RUN cd /home/$USERNAME/scripts && ./hear_mc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME


ADD /src/common/scripts/hear_arch/hear_configurations_install.sh /home/$USERNAME/scripts/hear_configurations_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_configurations_install.sh
RUN cd /home/$USERNAME/scripts && ./hear_configurations_install.sh

# RUN bash -c "source /opt/ros/noetic/setup.bash"
# RUN bash -c "echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc"
# RUN bash -c "source /home/$USERNAME/.bashrc"

# RUN bash -c "source /home/$USERNAME/$WS_NAME/devel/setup.bash"
# RUN bash -c "echo "source /home/$USERNAME/$WS_NAME/devel/setup.bash" >> /home/$USERNAME/.bashrc"
# RUN bash -c "source /home/$USERNAME/.bashrc"

ADD /src/core/docker/entrypoint.sh /
#COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

