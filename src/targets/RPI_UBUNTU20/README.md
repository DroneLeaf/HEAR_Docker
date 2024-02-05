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

cd HEAR_Docker
sudo chmod -R +x src/targets/RPI_UBUNTU20

cd src/targets/RPI_UBUNTU20

sudo ./full_system_installation.sh


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

## Enable UART communication on Pi4 Ubuntu 20.04

```bash
sudo chmod +x src/common/scripts/RPI_UBUNTU20/UART_enable.sh

./src/common/scripts/RPI_UBUNTU20/UART_enable.sh

```




 # How To use `Cross-Compilation`  or docker `build and run`
All instructions is [here](Docker_Running.md)


---
<br>

# How to change the Hostname


1. **Check the cloud-init configuration file:**

```bash
sudo nano /etc/cloud/cloud.cfg
```
Look for a line like `preserve_hostname`: false and change it to `true`. Save the file.

2. **Set new hostname**

```bash
sudo hostnamectl set-hostname ${"newhostname"}
```
 3. **Edit the /etc/hosts file to reflect the new hostname. Open the file with a text editor:**

 ```bash
 sudo nano /etc/hosts
 ```
 Find the line that starts with 127.0.1.1 and replace the old hostname with the new one. Save the changes and exit the editor.

For example, if your old hostname was "raspberrypi" and your new hostname is "myraspberrypi," you would change this line.

4. **Reboot your Raspberry Pi to apply the changes:**

```bash
sudo reboot
```

# Available PreBuilt images:

>>Just upload the image inside target directory and grab the download link

>> ⚠️⚠️  DEVELOPMENT upload directory\
**RPI_UBUNTU20**
https://droneleaf.sharepoint.com/:f:/s/technical/Epcvs8djDgBBmDXRLSfzWqwBDuH-a8uszOdTgNiNsdsTeQ?e=aLNODQ



- **DEVELOPMENT**

| Author   |      Date      |  LINK |
|----------|:-------------:|:------:|
| developer name |  7/JAN/2024 | https://test.com |

<br>
 
---
<br>




>> ⚠️⚠️  PRODUCTION upload directory\
**RPI_UBUNTU20**
https://droneleaf.sharepoint.com/:f:/s/technical/ErfDGvngD4NGpYUM4kqV0pcBgpX_CMDXZwGzjy3LMAr-rw?e=xcnotr


- **PRODUCTION**    


| Author   |      Date      |  LINK |
|----------|:-------------:|:------:|
| developer name |  7/JAN/2024 | https://test.com |
