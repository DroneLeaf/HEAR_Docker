
# HEAR-CLI


`HEAR-CLI` is a management tool designed to help droneleafers in daily development tasks , by gathering and execute all repeated HEAR Commands in a single CLI.




## Install `hear-cli`
 Version: *1.0.0*

>> we can install `hear-cli` via `pip` as a python package
```bash
cd ~/HEAR_Docker

pip install --user hear-cli/hear_cli.whl
```

## Commnads
 - upload
 - fleet
 - dev
   - build
   - configure
 - target
    - init
    - configure
    - docker
      - build
      - pull
      - run
      - configure



---
# 1- upload 
Upload cross-compiled file to aws s3 , with a `--filepath` and `--remotefilename` options. 

**Execution path** :

- anywhere at your system

**Usage**
```bash
hear-cli upload
```

# 2- fleet
Remotly access to all `hear_configurtions drones` and download cross-compiled files, update ROS_MASTER_URI, and update drone_name launch arg  on all `hear_configurtions drones`

**Execution path** :

- HEAR_Docker repo root path. `Recommended`

- anywhere at your system

**Usage**
```bash
hear-cli fleet
```

# 3- dev 
Build HEAR_FC or HEAR_MC for a choosen target

 - dev
   - build
   - configure

**Execution path** :

- HEAR_FC or HEAR_MC workspaces paths


**Usage**

Build hear_mc or hear_fc projects with a choosen target
```bash
hear-cli dev build
```

Update current command saved arguments that already been set
```bash
hear-cli dev configure
```


# 4- target
All HEAR Targets managements

- target
    - init
    - configure
    - docker
      - build
      - pull
      - run
      - configure

**Execution path** :

- HEAR_Docker repo root path.


**Usage**

Make a full installation of all prerequisites and dependencies needs to start your workspace
```bash
hear-cli target init
```

Update current command saved arguments that already been set
```bash
hear-cli target configure
```
##  ** target docker
All docker operations for targets

Target docker build for docker Cross Compilation
```bash
hear-cli target docker build
```

Docker run builded image and start dev workspace
```bash
hear-cli target docker run
```

Docker pull pre builded docker image for specific target
```bash
hear-cli target docker pull
```

Update current command saved arguments that already been set
```bash
hear-cli target docker configure
```