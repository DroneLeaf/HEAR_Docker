# HEAR Docker Getting Started Guide

# How to setup workspace


 ## **Prerequisites**
- ### Install System Requirements
   1. Install Docker Engine on Ubuntu : From Here https://docs.docker.com/engine/install/ubuntu



   2. Run Full Target System Requirements installation by running ```full_system_installation.sh``` file for the desired Target.

<br>

<div style="font-weight: 700;    
    display: flex;
    justify-content: center;
    align-items: center;">  
    You can find All Targets from
    <a class="top-link hide" style="box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);margin:10px 10px;color:white;background: linear-gradient(174deg, rgba(33,171,72,1) 0%, rgba(9,90,121,1) 52%, rgba(0,104,255,1) 100%);
;padding:15px 40px;border-radius: 20px !important;border:1px solid #fff;text-decoration: none;" href="#Targets">Here</a>
</div>

<br>
<br>

> Hint : The Main Dockerfile is suitable for all Build Targets 



- ### Install Docker Cross Compilation platforms

```bash 
sudo apt-get install -y qemu qemu-user-static

```
<br>

- ### Clone Hear_Docker Repo
```bash
cd
git clone https://github.com/ahmed-hashim-pro/HEAR_Docker.git
```

--- 

<br>
<br>

## **BUILD AND RUN**
> If you want to use docker Multi-Platform Builds: ```Dockerfile Cross-Compilation``` , plaese navigate to [Targets](#Targets)
- ### How To Build The Docker Image ```For Local platform target (Your local machine)```
> These instructions for Build and Run docker image on current host machine not for docker cross compile 



> Hint: You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

**Make sure you are at the same directory level with Dockerfile at Repo Root**


```bash 
cd ~/HEAR_Docker

docker build \
--progress=plain \
--build-arg GITHUB_ID="ID_HERE" \
--build-arg GITHUB_TOKEN="TOKEN_HERE" \
--build-arg TARGET_RPI="OFF" \
--build-arg TARGET_UBUNTU="ON" \
-t fc \
.

```

- ### How To Run The Docker Image

```bash 
docker run -t -d fc
```
---

<br>

 <a id="Targets"></a>
# Targets

* RPi_UbuntuSer20_noWeb
   * [RPI Target Installation](/RPi_UbuntuSer20_noWeb/RPI_Target_installation.md) 
      >To RUN Full Target system installation sh file
   * [RPI Target Running Docker](/RPi_UbuntuSer20_noWeb/RPI_Target_Running.md)
     >To BUILD AND RUN Docker 
