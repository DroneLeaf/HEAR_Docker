# RPi Ubuntu Server 20.04 Workspace Installation

**Hardware**: Raspberry Pi 4 Model B

**OS**: Ubuntu 20.04 Server

---

> * 🔴❗❗💡 **HINT: This file is not for docker build or cross-compile, it is for initialize target OS.** \
> If you need Docker `Cross-Compilation` please go [here](Docker_Running.md)

**This Documintation will help you in :**


* Init Target OS
* Setup Dev Workspace
* Setup Prod Workspace
* Update Target OS Configurations
* Install All Required Dependencies


### All installation commands are written in sh files separated by installation stages

- base.sh
- cmake_install.sh
- ros_install.sh
- dependencies_install.sh
- mavros_install.sh

#### All these files will be excuted from a single sh file `full_system_installation.sh`

# How to run

```bash
cd

git clone https://github.com/ahmed-hashim-pro/HEAR_Docker

sudo chmod -R +x HEAR_Docker/src/targets/RPI_UBUNTU20

cd HEAR_Docker/src/targets/RPI_UBUNTU20

sudo ./full_system_installation.sh


```



 # How To use `Cross-Compilation`  or docker `build and run`
All instructions is [here](Docker_Running.md)
