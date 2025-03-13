#ARM64
#AMD64
ARG opencv_url=base
ARG qt_url=base

FROM geohashim/ros AS base
LABEL org.opencontainers.image.title="crosscompiling system" 
LABEL org.opencontainers.image.description="Create prebuilded images for specific platforms" 
LABEL org.opencontainers.image.authors="Ahmed Hashim" 
LABEL org.opencontainers.image.documentation="https://github.com/DroneLeaf/HEAR_Docker" 
LABEL org.opencontainers.image.version="1.0.0" 
ARG DEBIAN_FRONTEND=noninteractive # ignore user input required
# Install required build dependencies

CMD ["bash"]

FROM geohashim/vcpkg AS vcpkg_img
ARG DEBIAN_FRONTEND=noninteractive


RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install cpr
RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install rapidjson
RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Context
RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Filesystem
RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-System
RUN cd ~/vcpkg && VCPKG_FORCE_SYSTEM_BINARIES=1 ./vcpkg install boost-Regex

CMD ["bash"]


#geohashim/opencv:4.0.0
# Make opencv image url as an arg so we can throw real opencv url
# to activate opencv install only for specific targets or throw base stage name to install nothing and avoid errors
FROM $opencv_url AS opencv_base
CMD ["bash"]

#geohashim/qt
FROM $qt_url AS qt_base
RUN mkdir -p /opt/Qt5.15
CMD ["bash"]


FROM base AS final
ARG DEBIAN_FRONTEND=noninteractive
RUN cd ~/

# We have to update ipc msgmax so we can receive onnx data and for activate ipc on ubntu image
RUN sysctl -w kernel.msgmax=65536

RUN echo dpkg -L opencv

# vcpkg_img contents
COPY --from=vcpkg_img /root/vcpkg  /root/vcpkg


# # ros_base contents
# COPY --from=ros_base /usr/include  /usr/include
# COPY --from=ros_base /usr/lib  /usr/lib
# COPY --from=ros_base /usr/share  /usr/share
# COPY --from=ros_base /opt/ros  /opt/ros

# opencv_base contents
COPY --from=opencv_base usr/local  usr/local


# qt_base contents
COPY --from=qt_base /opt/Qt5.15  /opt/Qt5.15


ARG USERNAME
ARG WS_NAME
ARG TARGET_RPI=OFF
ARG TARGET_UBUNTU=OFF
ARG TARGET_ORIN=OFF
ARG TARGET="ORIN"
ARG COMPILE_BRANCH="dev"
# ARG GITHUB_ID
# ARG GITHUB_TOKEN

RUN apt-get -y install keyboard-configuration


# setup git credentials
RUN git config --global user.name "docker image"


RUN --mount=type=secret,id=GITHUB_ID,target=/run/secrets/GITHUB_ID \
    --mount=type=secret,id=GITHUB_TOKEN,target=/run/secrets/GITHUB_TOKEN \
    GITHUB_ID_SECRET=$(cat /run/secrets/GITHUB_ID) && \
    GITHUB_TOKEN_SECRET=$(cat /run/secrets/GITHUB_TOKEN) &&\
    git config \
    --global \
    url."https://${GITHUB_ID_SECRET}:${GITHUB_TOKEN_SECRET}@github.com/".insteadOf \
    "https://github.com/"




# RUN git config \
#     --global \
#     url."https://${GITHUB_ID}:${GITHUB_TOKEN}@github.com/".insteadOf \
#     "https://github.com/"



ADD /src/common/scripts/dependencies_install.sh /scripts/dependencies_install.sh
RUN chmod +x scripts/dependencies_install.sh
RUN ./scripts/dependencies_install.sh

# ADD /src/common/scripts/px4/mavros_install.sh /scripts/mavros_install.sh
# RUN chmod +x scripts/mavros_install.sh
# RUN ./scripts/mavros_install.sh

# RUN apt-get update && apt-get install -y python3 python3-distutils python3-pip python3-apt

ADD /src/common/scripts/px4/mavlink_install.sh /scripts/mavlink_install.sh
RUN chmod +x scripts/mavlink_install.sh
RUN ./scripts/mavlink_install.sh


### All Sections variance here

####################### 1️⃣ RPI_UBUNTU20  ########################
# 1. RPI_UBUNTU20 Section Start

# #### add and expose sh files👇👇


# #### target condition execute
RUN if [ "$TARGET" = "RPI" ]; then\
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
RUN if [ "$TARGET" = "SITL" ]; then\
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
RUN if [ "$TARGET" = "ORIN" ]; then\
     # run your sh file here 👇👇
     # ./scripts/Qgroundcontrol_install.sh; \
    ./scripts/Kalibr.sh; \
    echo "TARGET_ORIN Applied";\
    #
  fi;

####################### 👌 END Target 👌 ######################## 





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


#RUN mkdir -p /HEAR_FC/src

# RUN cd /HEAR_FC/src  &&  git clone -b devel https://github.com/DroneLeaf/HEAR_FC.git HEAR_FC
# RUN cd /HEAR_FC/src/HEAR_FC && git submodule update --init --recursive

# ARG TARGET_RPI
# ARG TARGET_UBUNTU

RUN echo "Current active target is $TARGET"
RUN echo "Current active branch is $COMPILE_BRANCH"

RUN mkdir -p /home/$USERNAME/scripts

RUN touch /home/$USERNAME/.bashrc


# RUN pip install empy

# RUN apt-get -y update && apt install --no-install-recommends python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

# RUN apt install python3-rosdep -y
# # RUN rosdep init \
# #  && rosdep fix-permissions \
# #  && rosdep update
# RUN ls
# RUN cmake --version
ARG IS_PRODUCTION


# ADD /src/common/scripts/hear_arch/hear_configurations_install.sh /home/$USERNAME/scripts/hear_configurations_install.sh
# RUN chmod +x  /home/$USERNAME/scripts/hear_configurations_install.sh
# RUN cd /home/$USERNAME/scripts && ./hear_configurations_install.sh

# RUN if [  "$IS_PRODUCTION" = "TRUE" ]; then\
#     #
#     rm -r ~/HEAR_Configurations/.git; \
#     rm  ~/HEAR_Configurations/.gitignore; \
#     #
#   fi;


ADD /src/common/scripts/hear_arch/hear_Msgs_install.sh /home/$USERNAME/scripts/hear_Msgs_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_Msgs_install.sh
RUN cd /home/$USERNAME/scripts && ./hear_Msgs_install.sh $TARGET /home/$USERNAME/HEAR_Msgs $COMPILE_BRANCH

RUN if [  "$IS_PRODUCTION" = "TRUE" ]; then\
    #
    rm -r /home/$USERNAME/HEAR_Msgs/src/HEAR_Msgs/.git; \
    rm  /home/$USERNAME/HEAR_Msgs/src/HEAR_Msgs/.gitignore; \
    #
  fi;



ADD /src/common/scripts/hear_arch/hear_fc_install.sh /home/$USERNAME/scripts/hear_fc_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_fc_install.sh
RUN if [ "$WS_NAME" = "HEAR_FC" ]; then\
    #
    cd /home/$USERNAME/scripts && ./hear_fc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME $TARGET $COMPILE_BRANCH; \
    #
  fi;

RUN if [ "$WS_NAME" = "HEAR_FC" ] && [  "$IS_PRODUCTION" = "TRUE" ]; then\
    #
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/HEAR_Blocks; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/HEAR_executables; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/HEAR_Interfaces; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/HEAR_Mission; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/HEAR_Util; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/HEAR_flight_controller; \
    rm  /home/$USERNAME/HEAR_FC/src/HEAR_FC/Flight_controller/Configurations.cmake; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/.vscode; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/.idea; \
    rm -r /home/$USERNAME/HEAR_FC/src/HEAR_FC/.git; \
    rm  /home/$USERNAME/HEAR_FC/src/HEAR_FC/.gitignore; \
    rm  /home/$USERNAME/HEAR_FC/src/HEAR_FC/.gitmodules; \
    rm  /home/$USERNAME/HEAR_FC/src/HEAR_FC/README.md; \
    #
  fi;
# RUN cd /home/$USERNAME/scripts && ./hear_fc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME

ADD /src/common/scripts/hear_arch/hear_mc_install.sh /home/$USERNAME/scripts/hear_mc_install.sh
RUN chmod +x  /home/$USERNAME/scripts/hear_mc_install.sh
RUN if [ "$WS_NAME" = "HEAR_MC" ]; then\
    #
    cd /home/$USERNAME/scripts && ./hear_mc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME $TARGET $COMPILE_BRANCH; \
    #
  fi;




RUN if [ "$WS_NAME" = "HEAR_MC" ] && [  "$IS_PRODUCTION" = "TRUE" ]; then\
    #
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/HEAR_Blocks; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/HEAR_Interfaces; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/HEAR_Mission; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/HEAR_Util; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/example_node; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_MC_Realization/Configurations.cmake; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_Mission_Control; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_Msgs; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/HEAR_msgs; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/.git; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/.gitignore; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/.gitmodules; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/Profiling.md; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/README.md; \
    rm  /home/$USERNAME/HEAR_MC/src/HEAR_MC/installation_of_packages.txt; \
    rm -r /home/$USERNAME/HEAR_MC/src/HEAR_MC/.vscode; \
    #
  fi;



## remove scripts folder in production mode
RUN if [ "$IS_PRODUCTION" = "TRUE" ]; then\
    #
    rm  -rf /scripts; \
    rm  -rf /home/$USERNAME/scripts; \
    #
  fi;




# RUN cd /home/$USERNAME/scripts && ./hear_mc_install.sh $TARGET_RPI $TARGET_UBUNTU $TARGET_ORIN /home/$USERNAME/$WS_NAME $USERNAME



RUN bash -c "source /opt/ros/noetic/setup.bash"
RUN bash -c "echo source /opt/ros/noetic/setup.bash >> '/root/.bashrc'"
RUN bash -c "source /root/.bashrc"

RUN bash -c "source /home/$USERNAME/$WS_NAME/devel/setup.bash"
RUN bash -c "echo source /home/$USERNAME/$WS_NAME/devel/setup.bash >> '/root/.bashrc'"
RUN bash -c "source /root/.bashrc"


# remove git credentials in production mode
RUN if [ "$IS_PRODUCTION" = "TRUE" ]; then\
    #
    rm -f ~/.gitconfig; \
    #
  fi;
RUN 


FROM base
ARG DEBIAN_FRONTEND=noninteractive
RUN cd ~/
COPY --from=final / /
ARG USERNAME
ARG WS_NAME

WORKDIR /home/$USERNAME/$WS_NAME

EXPOSE 80
EXPOSE 8080
EXPOSE 11311
EXPOSE 14540
EXPOSE 14580


ADD /src/core/docker/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

