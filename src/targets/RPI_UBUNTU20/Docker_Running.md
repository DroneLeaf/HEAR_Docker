# Raspberry Pi Ubuntu Server 20.04 Docker Running

## BUILD AND RUN

* ### How To Build The Docker Image For ```ARM64 Target Platform``` 


**Make sure you are at the same directory level with Dockerfile at Repo Root**

> Hint: You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
```bash 
cd ~/HEAR_Docker

echo {GITHUB_ID_HERE} > secrets/GITHUB_ID
echo {GITHUB_TOKEN_HERE} > secrets/GITHUB_TOKEN

docker build \
--platform=linux/arm64 \
--progress=plain \
--secret id=GITHUB_ID,src=secrets/GITHUB_ID \
--secret id=GITHUB_TOKEN,src=secrets/GITHUB_TOKEN \
--build-arg TARGET_RPI="ON" \
--build-arg USERNAME="pi" \
--build-arg WS_NAME="HEAR_FC" \
--build-arg IS_PRODUCTION="FALSE" \
-t fc_rpi \
.

```

- ### How To Run The Docker Image

```bash 
docker run -it -d fc_rpi --entrypoint bash
```


- ### how To Copy compiled files to host machine
1. Get ```"CONTAINER ID"``` of ```'fc_rpi'``` image
```bash 
docker ps | grep 'fc_rpi' | awk '{print $1}'
```

2. copy ```"CONTAINER ID"``` of ```'fc_rpi'``` image from the bash output

3. Run this Bash CMD with ```"CONTAINER ID"``` you copied
```bash
sudo docker cp {CONTAINER ID}:/home/pi/HEAR_FC src/targets/RPI_UBUNTU20/compiled_files

# EX: docker cp 7a349451cdc9:/home/pi/HEAR_FC src/targets/RPI_UBUNTU20/compiled_files

```

4. Now you can find copied docker image output here >>> ```src/targets/RPI_UBUNTU20/compiled_files```

> fell free to use the so libraries inside ```/compiled_files/devel/lib``` folder

<br>

# Upload hear_fc devel to AWS S3

```bash
# install needed packages
pip3 install boto3
pip3 install progressbar
apt install zip

# go to project root
cd ~/HEAR_Docker

# zip desired folder
pushd src/targets/RPI_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

# upload zipped file
python3 src/core/utils/s3Upload.py \
 hear_fc_devel.zip # cloud file name ,will be used for download


```
- Download file on other machine

```bash
wget https://hear-bucket.s3.me-south-1.amazonaws.com/hear_arch/hear_fc_devel.zip 

unzip hear_fc_devel.zip -d compiled_files
cp -r  compiled_files/compiled_files ~/HEAR_FC
```

<br>

# Transfer via ssh to raspberry pi

**We can do that In 2 steps, One For Each Device**

1- On local Machine

```bash
# zip desired folder
pushd src/targets/RPI_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

# copy to raspberry pi device
sudo scp hear_fc_devel.zip pi@{ip}:/home/pi/hear_fc_devel.zip


```

2- On Raspberry Pi

``` bash

unzip hear_fc_devel.zip -d compiled_files

cp -r  compiled_files/compiled_files ~/HEAR_FC

```

# How To Open `Remote Dev Workspace` inside docker container via vscode

1. install Docker extension : \
 open the Extensions view (Ctrl+Shift+X), search for docker to filter results and select Docker extension authored by Microsoft.

![Docker vs extension](https://camo.githubusercontent.com/1c9f7f92c774e1b5a79192b3ed142c4206b2fcc6366b1ab1da513a7c13356ece/68747470733a2f2f636f64652e76697375616c73747564696f2e636f6d2f6173736574732f646f63732f636f6e7461696e6572732f6f766572766965772f696e7374616c6c6174696f6e2d657874656e73696f6e2d7365617263682e706e67)

2. Make sure that the container is running by getting it's id \
⚠️⚠️ If you got an id then ignore step 2
```bash
# 1. check if the fc_rpi image is running by get it's id
docker ps | grep 'fc_rpi' | awk '{print $1}'
# if you got an id then ignore step 2

# 2. Run fc_rpi docker image
docker run -it -d fc_rpi --entrypoint bash
```

3. Open remote access on docker container workspace via vscode

![Docker vs extension](/container_dev_instructions.gif)

4. start develop inside docker container 

5. Copy compiled files to host machine and transfer to deployment target

