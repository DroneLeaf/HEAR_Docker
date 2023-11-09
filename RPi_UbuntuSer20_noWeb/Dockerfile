FROM ubuntu:20.04 AS base

ADD .. /


RUN chmod +x /full_system_installation.sh
# RUN chmod +x /base.sh
# RUN chmod +x /cmake_install.sh
# RUN chmod +x /vcpkg_install.sh
# RUN chmod +x /opencv_install.sh
# RUN chmod +x /ros_install.sh

RUN ./full_system_installation.sh
# RUN ./base.sh
# RUN ./cmake_install.sh aarch64

# RUN ./vcpkg_install.sh
# RUN ./opencv_install.sh
# RUN ./ros_install.sh

