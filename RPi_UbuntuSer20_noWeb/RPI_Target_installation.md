# RPi Ubuntu Server 20.04 Workspace Installation

### All installation commands are written in sh files separated by installation stages

- base.sh
- cmake_install.sh
- vcpkg_install.sh
- opencv_install.sh
- ros_install.sh
- dependencies_install.sh

#### All these files will be excuted from a single sh file `full_system_installation.sh`

### How to run

```bash
cd

git clone https://github.com/ahmed-hashim-pro/HEAR_Docker

sudo chmod -R +x HEAR_Docker/RPi_UbuntuSer20_noWeb

cd HEAR_Docker/RPi_UbuntuSer20_noWeb

sudo ./full_system_installation.sh


```



- ### How To Build The Docker Image For ARM64 target
> please go [here](RPI_Target_Running.md)
