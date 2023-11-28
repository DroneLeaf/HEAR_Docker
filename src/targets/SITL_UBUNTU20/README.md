# SITL Ubuntu Server 20.04 Workspace Installation


Hardware: amd64 device

OS: Ubuntu 20.04


**This Documintation will help you in :**


* Init Target OS
* Setup Dev Workspace
* Setup Prod Workspace
* Update Target OS Configurations
* Install All Required Dependencies

> If you need docker build and run please go [here](Docker_Running.md)


### All installation commands are written in sh files separated by installation stages

- base.sh
- cmake_install.sh
- vcpkg_install.sh
- opencv_install.sh
- ros_install.sh
- dependencies_install.sh
- mavros_install.sh
- mavlink_install.sh

#### All these files will be excuted from a single sh file `full_system_installation.sh`

### How to run

```bash
cd

git clone https://github.com/ahmed-hashim-pro/HEAR_Docker

sudo chmod -R +x HEAR_Docker/RPI_UBUNTU20

cd HEAR_Docker/RPI_UBUNTU20

sudo ./full_system_installation.sh


```



- ### How To Build The Docker Image For AMD64 target
> please go [here](Docker_Running.md)
