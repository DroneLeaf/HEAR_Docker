# Raspberry Pi Ubuntu Server 20.04 Docker Running

## BUILD AND RUN

* ### How To Build The Docker Image For ```ARM64 Target Platform``` 


**Make sure you are at the same directory level with Dockerfile at Repo Root**

> Hint: You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
```bash 
cd ~/HEAR_Docker

docker build \
--platform=linux/arm64 \
--progress=plain \
--build-arg GITHUB_ID="{ID_HERE}" \
--build-arg GITHUB_TOKEN="{TOKEN_HERE}" \
--build-arg TARGET_ORIN="ON" \
--build-arg opencv_url="cyrilix/opencv-runtime:4.8.0" \
--build-arg USERNAME="{username}" \
--build-arg WS_NAME="HEAR_FC" \

-t fc_orin \
.

```

- ### How To Run The Docker Image

```bash 
docker run -it -d fc_orin "/home/{username}/HEAR_FC"  "roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV"
```


- ### how To Copy compiled files to host machine
1. Get ```"CONTAINER ID"``` of ```'fc_orin'``` image
```bash 
docker ps -a  | grep 'fc_orin' | awk '{print $1}'
```

2. copy ```"CONTAINER ID"``` of ```'fc_orin'``` image from the bash output

3. Run this Bash CMD with ```"CONTAINER ID"``` you copied
```bash
sudo docker cp {CONTAINER ID}:/home/{username}/HEAR_FC src/targets/ORIN_UBUNTU20/compiled_files

# EX: docker cp 7a349451cdc9:/home/{username}/HEAR_FC src/targets/ORIN_UBUNTU20/compiled_files

# close and remove fc_orin runing container to save machine resources
sudo docker rm -f {CONTAINER ID}
```

4. Now you can find copied docker image output here >>> ```src/targets/ORIN_UBUNTU20/compiled_files```

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
pushd src/targets/ORIN_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

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
pushd src/targets/ORIN_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

# copy to raspberry pi device
sudo scp hear_fc_devel.zip pi@{ip}:/home/{username}/hear_fc_devel.zip


```

2- On Raspberry Pi

``` bash

unzip hear_fc_devel.zip -d compiled_files

cp -r  compiled_files/compiled_files ~/HEAR_FC

```
