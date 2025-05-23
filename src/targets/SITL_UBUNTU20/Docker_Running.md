# SITL Ubuntu Server 20.04 Docker Running

## BUILD AND RUN

* ### How To Build The Docker Image For ```AMD64 Target Platform``` 


**Make sure you are at the same directory level with Dockerfile at Repo Root**

> Hint: You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
```bash 
cd ~/HEAR_Docker

echo {GITHUB_ID_HERE} > secrets/GITHUB_ID
echo {GITHUB_TOKEN_HERE} > secrets/GITHUB_TOKEN

docker build \
--platform=linux/amd64 \
--progress=plain \
--secret id=GITHUB_ID,src=secrets/GITHUB_ID \
--secret id=GITHUB_TOKEN,src=secrets/GITHUB_TOKEN \
--build-arg TARGET_UBUNTU="ON" \
--build-arg opencv_url="geohashim/opencv:4.0.0" \
--build-arg qt_url="geohashim/qt" \
--build-arg USERNAME="{username}" \
--build-arg WS_NAME="HEAR_FC" \
--build-arg IS_PRODUCTION="FALSE" \
-t fc_sitl \
.

```

- ### How To Run The Docker Image

```bash 
docker run -it -d fc_sitl "/home/{username}/HEAR_FC"  "roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV"
```


- ### how To Copy compiled files to host machine
1. Get ```"CONTAINER ID"``` of ```'fc_sitl'``` image
```bash 
docker ps -a  | grep 'fc_sitl' | awk '{print $1}'
```

2. copy ```"CONTAINER ID"``` of ```'fc_sitl'``` image from the bash output

3. Run this Bash CMD with ```"CONTAINER ID"``` you copied
```bash
sudo docker cp {CONTAINER ID}:/home/{username}/HEAR_FC src/targets/SITL_UBUNTU20/compiled_files

# EX: docker cp 7a349451cdc9:/home/hashim/HEAR_FC src/targets/RPI_UBUNTU20/compiled_files

# close and remove fc_arm64 runing container to save machine resources
sudo docker rm -f {CONTAINER ID}
```

4. Now you can find copied docker image output here >>> ```/compiled_files```

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
pushd src/targets/SITL_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

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

# Transfer via ssh to target device

**We can do that In 2 steps, One For Each Device**

1- On local Machine

```bash
# zip desired folder
pushd src/targets/SITL_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

# copy to target device
sudo scp hear_fc_devel.zip {username}@{ip}:/home/{username}/hear_fc_devel.zip


```

2- On target device

``` bash

unzip hear_fc_devel.zip -d compiled_files

cp -r  compiled_files/compiled_files ~/HEAR_FC

```
