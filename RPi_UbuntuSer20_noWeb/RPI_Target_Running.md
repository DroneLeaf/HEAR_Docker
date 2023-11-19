# RPi Ubuntu Server 20.04 Workspace Running


- ### How To Build The Docker Image For ```ARM64 Target Platform``` 


**Make sure you are at the same directory level with Dockerfile at Repo Root**

> Hint: You need your ```GITHUB_ID``` and ```GITHUB_TOKEN``` for git clone src folder.\
you can generate one as described [here](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
```bash 
cd ~/HEAR_Docker

docker build \
--platform=linux/arm64 \
--progress=plain \
--build-arg GITHUB_ID="ID_HERE" \
--build-arg GITHUB_TOKEN="TOKEN_HERE" \
--build-arg TARGET_RPI="ON" \
--build-arg TARGET_UBUNTU="OFF" \
--build-arg opencv_url="base" \
--build-arg USERNAME="pi" \
--build-arg WS_NAME="HEAR_FC" \

-t fc_arm64 \
.

```

- ### How To Run The Docker Image

```bash 
docker run -it -d fc_arm64 "/home/pi/HEAR_FC"  " roslaunch flight_controller flight_controller.launch DRONE_NAME:=UAV"
```


- ### how To Copy compiled files to host machine
1. Get ```"CONTAINER ID"``` of ```'fc_arm64'``` image
```bash 
docker container ls  | grep 'fc_arm64' | awk '{print $1}'
```

2. copy ```"CONTAINER ID"``` of ```'fc_arm64'``` image from the bash output

3. Run this Bash CMD with ```"CONTAINER ID"``` you copied
```bash
docker cp {CONTAINER ID}:/HEAR_FC /compiled_files

# EX: docker cp 7a349451cdc9:/HEAR_FC /compiled_files
```

4. Now you can find copied docker image output here >>> ```/compiled_files```

> fell free to use the so libraries inside ```/compiled_files/devel/lib``` folder


