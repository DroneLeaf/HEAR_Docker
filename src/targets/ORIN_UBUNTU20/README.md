# ORIN Ubuntu Server 20.04 Workspace Installation

**Hardware**: Jetson Orin Nano

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
- vcpkg_install.sh
- opencv_install.sh
- ros_install.sh
- dependencies_install.sh
- mavros_install.sh
- mavlink_install.sh
- Qgroundcontrol_install.sh


#### All these files will be excuted from a single sh file `full_system_installation.sh`

# How to run

```bash
cd

git clone https://github.com/DroneLeaf/HEAR_Docker

cd HEAR_Docker
sudo chmod -R +x src/targets/ORIN_UBUNTU20

cd src/targets/ORIN_UBUNTU20

./full_system_installation.sh



```

- ⚠️⚠️ **If you can not find roslaunch after install ros**

```bash
# source ros
source /opt/ros/noetic/setup.bash
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

```

- ⚠️⚠️ **If you can not find px4 after install mavros**

```bash
# source px4
source ~/catkin_ws/devel/setup.bash
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

```





 # How To use `Cross-Compilation`  or docker `build and run`
All instructions is [here](Docker_Running.md)


# Camera Setup and Calibration
All instructions is [here](camera_calibration.md)


# NVMe Installation Guide
All instructions is [here](NVMe_Installation.md)



# Available PreBuilt images:

>>Just upload the image inside target directory and grab the download link


>> ⚠️⚠️  DEVELOPMENT upload directory\
>> **ORIN_UBUNTU20**
https://droneleaf.sharepoint.com/:f:/s/technical/EkNVPxWC6YdPo82ESxa7CpcB3G8scw4YFN2uTX1I8HYOEw?e=0LUICw

- **DEVELOPMENT**

| Author   |      Date      |  LINK |
|----------|:-------------:|:------:|
| developer name |  7/JAN/2024 | https://test.com |

<br>
 
---
<br>




>> ⚠️⚠️  PRODUCTION upload directory\
>> **ORIN_UBUNTU20**
https://droneleaf.sharepoint.com/:f:/s/technical/EkmAyGBlZShFvVII91LPNH4BftBT4xf5gwoFZQI6Bsj9TA?e=LB4Vv6


- **PRODUCTION**    


| Author   |      Date      |  LINK |
|----------|:-------------:|:------:|
| developer name |  7/JAN/2024 | https://test.com |
