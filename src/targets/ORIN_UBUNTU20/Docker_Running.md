# Jetson Orin Ubuntu Server 20.04 Docker Running

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
--build-arg TARGET_ORIN="ON" \
--build-arg opencv_url="geohashim/opencv:4.0.0" \
--build-arg qt_url="geohashim/qt" \
--build-arg USERNAME="{username}" \
--build-arg WS_NAME="HEAR_FC" \
--build-arg IS_PRODUCTION="FALSE" \
-t fc_orin \
.

```

- ### How To Run The Docker Image

```bash 
docker run -it -d fc_orin --entrypoint bash

# docker run -it -d fc_orin "/home/{username}/HEAR_FC"  "roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV"
# docker run -it -d fc_orin "/home/{username}/HEAR_FC"  "roslaunch flight_controller PX4_SITL.launch DRONE_NAME:=UAV"


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
# sudo docker rm -f {CONTAINER ID}
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

aws configure set aws_access_key_id "AKIAUJ6SOV74EPNOMEGF" --profile s3download && aws configure set aws_secret_access_key "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" --profile s3download && aws configure set region "me-south-1" --profile s3download


aws s3api get-object --bucket hear-bucket --key hear_arch/hear_fc_devel.zip hear_fc_devel.zip --profile s3download

wget https://hear-bucket.s3.me-south-1.amazonaws.com/hear_arch/hear_fc_devel.zip 

unzip hear_fc_devel.zip -d compiled_files
cp -r  compiled_files/compiled_files ~/HEAR_FC
```

<br>

# Transfer via ssh to jetson orin

**We can do that In 2 steps, One For Each Device**

1- On local Machine

```bash
# zip desired folder
pushd src/targets/ORIN_UBUNTU20; sudo zip -r ../../../hear_fc_devel.zip ./compiled_files; popd

# copy to jetson orin device
sudo scp hear_fc_devel.zip {deviceName}@{ip}:/home/{username}/hear_fc_devel.zip


```

2- On Jetson Orin

``` bash

unzip hear_fc_devel.zip -d compiled_files

cp -r  compiled_files/compiled_files ~/HEAR_FC

```


# get prebuilded docker image from aws

```bash
sudo apt  install awscli -y

aws configure set aws_access_key_id "AKIAUJ6SOV74AAMHJYHS" --profile ecrpush && aws configure set aws_secret_access_key "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" --profile ecrpush && aws configure set region "me-south-1" --profile ecrpush

aws ecr get-login-password --region me-south-1 --profile ecrpush | docker login --username AWS --password-stdin 296257236984.dkr.ecr.me-south-1.amazonaws.com

docker pull 296257236984.dkr.ecr.me-south-1.amazonaws.com/hear_fc_orin:latest

docker tag  296257236984.dkr.ecr.me-south-1.amazonaws.com/hear_fc_orin:latest fc_orin:latest

```


# get prebuilded docker image from aws as a droneleaf client

```bash
sudo apt  install awscli -y

aws configure set aws_access_key_id "AKIAUJ6SOV74BIPDJCHB" --profile ecrpull && aws configure set aws_secret_access_key "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" --profile ecrpull && aws configure set region "me-south-1" --profile ecrpull

aws ecr get-login-password --region me-south-1 --profile ecrpull | docker login --username AWS --password-stdin 296257236984.dkr.ecr.me-south-1.amazonaws.com

docker pull 296257236984.dkr.ecr.me-south-1.amazonaws.com/hear_fc_orin:latest

docker tag  296257236984.dkr.ecr.me-south-1.amazonaws.com/hear_fc_orin:latest fc_orin:latest

```


