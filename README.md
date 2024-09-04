# HEAR Docker Getting Started Guide


# ⚠️⚠️💡📌📌`HEAR_CLI`: is an alternative way to execute most of HEAR_Docker commands is launched under the name of `hear-cli`

It is recommended to to use `hear-cli` instead of HEAR_Docker, however it is up to you any way 

 📌 `hear-cli` Documintations [here](hear-cli/README.md)


---


# HEAR Docker
# **Good To Know**

### Expressions
* **Full System Installation** : It mean To make a full installation of all prerequisites and dependencies needs to start your workspace in that target OS .
In Other way , this file will install ros, cmake, vcpkg and other dependencies on the OS itself not as docker container.

* **Local Machine** : It means Your local PC or Laptop.

* **Cross-Compilation** : To build on one platform a binary that will run on another platform ,in other mean , you want to build HEAR_FC on your local machine and execute generated code on raspberry pi or orin.

### ℹ️ℹ️ Hints and Tips 
* The Main Dockerfile in repo root is suitable for all Targets and no need to declare a Dockerfile for every target.
* The target folder is isolated from other targets and you do not need to read  all documented files to start work , just go to your favourite target and you will find what you need.
* All placeholders are encapsulated inside curly brackets like these `{}`, for example you will find `{ID_HERE}` or `{TOKEN_HERE}` , that meants you will replace them with desired value.
* You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder like HEAR_FC and HEAR_MC.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

---
<br>


# Getting Started
 ## **Prerequisites**
1. ### Install System Requirements
   1. Install Docker Engine on Ubuntu : From Here https://docs.docker.com/engine/install/ubuntu



   


2. ### Install Docker Cross Compilation platforms

```bash 
sudo apt-get install -y qemu qemu-user-static

# Check arm64 arch availability
docker buildx ls # you should see linux/arm64 arch 

```


3. ### Clone Hear_Docker Repo at home directory
```bash
cd
git clone https://github.com/DroneLeaf/HEAR_Docker.git
```


4. ### Run Full System  installation by running ```full_system_installation.sh``` file for the desired Target.

Every target needs to be initiated so you can start develop without any missing package , for that you will find a file called `full_system_installation.sh` in every target folder, by running this file of the desired target , you will init the target with no hassle.

<br>

<div style="font-weight: 700;    
    display: flex;
    justify-content: center;
    align-items: center;">  
    You can find More informations about Targets from
    <a class="top-link hide" style="box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);margin:10px 10px;color:white;background: linear-gradient(174deg, rgba(33,171,72,1) 0%, rgba(9,90,121,1) 52%, rgba(0,104,255,1) 100%);
;padding:15px 40px;border-radius: 20px !important;border:1px solid #fff;text-decoration: none;" href="#Targets">Here</a>
</div>

<br>
<br>

## **BUILD AND RUN**

All `Build and Run` instructions were typed separately inside each target itself.
this mean if you want to use `Dockerfile Cross-Compilation` for raspberry pi you will find the desired instructions inside `RPI_UBUNTU20` folder target itself and that applied for all targets.\
You can find all targets [here](#Targets)

--- 

<br>
<br>


<a id="Targets"></a>


# Targets

1. **RPI_UBUNTU20**
   * [Full System Installation](/src/targets/RPI_UBUNTU20/README.md) 

   * [Docker Cross-Compilation](/src/targets/RPI_UBUNTU20/Docker_Running.md)

2. **SITL_UBUNTU20**
   * [Full System Installation](/src/targets/SITL_UBUNTU20/README.md) 

   * [Docker Cross-Compilation](/src/targets/SITL_UBUNTU20/Docker_Running.md)

2. **ORIN_UBUNTU20**
   * [Full System Installation](/src/targets/ORIN_UBUNTU20/README.md) 

   * [Docker Cross-Compilation](/src/targets/ORIN_UBUNTU20/Docker_Running.md)






---

# **Repo Structure**
```bash
.
├── CONTRIBUTING.md
├── Dockerfile
├── README.md
└── src
    ├── common
    │   └── scripts
    │       ├── Qgroundcontrol_install.sh
    │       ├── base.sh
    │       ├── cmake_install.sh
    │       ├── dependencies_install.sh
    │       ├── hear_arch
    │       │   └── hear_fc_install.sh
    │       ├── opencv_install.sh
    │       ├── px4
    │       │   ├── mavlink_install.sh
    │       │   └── mavros_install.sh
    │       ├── ros_install.sh
    │       └── vcpkg_install.sh
    └── targets
        ├── ORIN_UBUNTU20
        │   ├── Docker_Running.md
        │   ├── README.md
        │   └── full_system_installation.sh
        ├── RPI_UBUNTU20
        │   ├── Docker_Running.md
        │   ├── README.md
        │   └── full_system_installation.sh
        └── SITL_UBUNTU20
            ├── Docker_Running.md
            ├── README.md
            └── full_system_installation.sh


```


# How to contribute 

All contribute Instructions can be found [Here](CONTRIBUTING.md)


# How to debug 

- ### Trick To Re-Run Part of the Docker Build Process
Lets say you want to pull latest changes from GitHub and rebuild. Docker always use cache to save time and memory , so if you want to override somthing in docker file build process without re build all docker file , just go above the line you want to re build and type 👇👇
```
RUN ls
```
this will re excute all bellow lines and override docker cache , but make sure to not fill the Dockerfile with this line and push changes to github , just use this trick locally .\
If you already write the line and want to override again, then remove it to override once again and repeat. no need to type it every time you want that,
just use it this way ➡️➡️ `add once then remove, and repeat...🔁🔁`

