
# HEAR-CLI


`HEAR-CLI` is a management tool designed to help droneleafers in daily development tasks , by gathering and execute all repeated HEAR Commands in a single CLI.


### Requirements
Python : V *3.8*
Docker

## Install `hear-cli`
 Version: *1.0.0*

>> we can install `hear-cli` via `pip` as a python package
```python
cd ~/HEAR_Docker
sudo apt install python3-pip -y
pip install --user hear-cli/hear_cli-1.3.0.tar.gz

# open new terminal and execute `hear-cli`
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
Access to all `HEAR_Configurtions` fleet drones. `HEAR_Configurtions` is pulled from GitHub `devel` branch. For each drone in the fleet the command will download cross-compiled files, update ROS_MASTER_URI based on user input, and update drone_name launch arg on all drones in the fleet.

Add all hosts to /etc/hosts
Change hostname in targets to be the instance name | hear-cli fleet update-host-names


Name property in each launch file| Example: 
<arg name="DRONE_NAME" /> 
<node name="$(arg DRONE_NAME)" pkg="flight_controller" type="window_node"  output="screen"/>

Ros bag record

hear-cli fleet setup

hear-cli fleet run --filename 
`filename will be user prompt` | note: from HEAR_Run

**Execution path** :

- HEAR_Docker repo root path. `Recommended`

- anywhere at your system

**Usage**
```bash
hear-cli fleet
```

# 3- dev 
Build HEAR_FC or HEAR_MC for a choosen target. Type `hear-cli dev --help` 

 - dev
   - build
   - configure

**Execution path** :

- Command must be run from HEAR_FC or HEAR_MC workspaces paths


**Example Usage**

Build hear_mc or hear_fc projects with a choosen target
```bash
cd ~/HEAR_FC
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