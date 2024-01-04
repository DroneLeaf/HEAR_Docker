
## Camera Setup and Calibration

- **Setting Up the Camera:**
  - Clone the camera repository:
    ```bash
    git clone https://github.com/oussamaabdulhay/elp.git
    ```

**⚠️⚠️  We have three options for Intrinsic Calibration, and we will use only option 1** 
>> ⚠️⚠️ The other two options is optional, they just for reference.
- **Option 1: Intrinsic Calibration : Using Kalibr:**
  - Install Kalibr and its requirements:
    ```bash
    sudo apt-get install -y \
        git wget autoconf automake nano \
        libeigen3-dev libboost-all-dev libsuitesparse-dev \
        doxygen libopencv-dev \
        libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev

    sudo apt-get install -y python3-dev python3-pip python3-scipy \
        python3-matplotlib ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx

    mkdir -p ~/kalibr_workspace/src
    cd ~/kalibr_workspace
    export ROS1_DISTRO=noetic # kinetic=16.04, melodic=18.04, noetic=20.04
    source /opt/ros/$ROS1_DISTRO/setup.bash
    catkin init
    catkin config --extend /opt/ros/$ROS1_DISTRO
    catkin config --merge-devel # Necessary for catkin_tools >= 0.4.
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release

    cd ~/kalibr_workspace/src
    git clone https://github.com/ethz-asl/kalibr.git

    cd ~/kalibr_workspace/
    catkin build -DCMAKE_BUILD_TYPE=Release -j4
    ```
  - Create a calibration pattern file (e.g., `april.yaml`) and specify camera model, topic, and bag file name.
    ```bash
    target_type: 'aprilgrid'
    tagCols: 6
    tagRows: 6
    tagSize: 0.06
    tagSpacing: 0.3
    ```
    save it as april.yaml
  
  - Run the Kalibr command for camera calibration.
  ```bash
    export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1

    rosrun kalibr kalibr_calibrate_cameras --target <april_file yaml> --models pinhole-equi --topics <topic name> --bag <bag_file name>
    ```


- **Option 2 :Intrinsic Calibration Using `camera_calibration` package:**
  - Install the package:
    ```bash
    sudo apt-get install ros-noetic-camera-calibration
    ```
  - Run the package and set the size of the checkeredboard and the square according to the borad available `rosrun camere_calibration cameracalibrator.py --size 10x7 --square 0.025 image:=/camera/image_raw --fisheye-k-coefficients=4`.
  - change the camera model to fisheye from pinhole using the scroll bar.
  - Start moving the calibration board around until all metric are green.
  -press calibrate when done.

- **Option 3: Intrinsic Calibration  Using `elp_camera_calibration.py`:**
  - Run the camera script:
    ```bash
    python elp_camera.py
    ```
  - Capture 30 images from different poses using `rosrun rqt_image_view rqt_image_view`.
  - Run the calibration file:
    ```bash
    python elp_camera_calibration.py
    ```


## IMU Calibration

- **Calculating IMU Bias and Random Walk:**
  - Install the Allan Variance package:
    ```bash
    mkdir -p ~/allan_variance_workspace/src
    cd ~/allan_variance_workspace/src
    git clone https://github.com/ori-drs/allan_variance_ros.git
    cd ~/allan_variance_workspace
    catkin build allan_variance_ros

    ```
  - Create an `imu.yaml` file with necessary details like imu_topic, imu_rate, etc.
  - Run the Allan Variance node:
    ```bash
    rosrun allan_variance_ros allan_variance <bag_file> <imu_yaml_file>
    ```
  - Adjust the noise density and random walk in the `imu.yaml` file as required.  It is important to multiply the noise density outputs in the "imu.yaml" by a factor of 5, and the random walk by 10.

## Extrinsic Calibration

- **Preparing for Calibration:**
  - Ensure the `imu.yaml` file and the intrinsic calibration output are ready.

- **Running Extrinsic Calibration:**
  - Use the Kalibr tool for IMU-camera calibration:
    ```bash
    rosrun kalibr kalibr_calibrate_imu_camera --imu-models calibrated --reprojection-sigma 1.0 --target <april_tag file name> --imu static_imu/imu.yaml --cams <intrinsic calibration file output> --bag <bag_file_name>
    ```

* The result of the extrinsic calibration should be added to HEAR_Configuratuin -> UAV_instances -> \<instance> -> general.json-> camera_pose 

## Troubleshooting and Tips

- **Common Issues:**
  - If you encounter errors while compiling HEAR_FC, delete the `build` and `devel` directories, run `catkin_make clean` twice, then `catkin build` again.

- **Additional Recommendations:**
  - Regularly check for updates or patches for the Nvidia SDK, Jetpack, and other software components.
  - Consult the official Nvidia forums or support channels for specific issues related to the Jetson Orin Nano Development Kit.

## Conclusion

- **Final Steps:**
  - Verify all installations and calibrations have been completed successfully.
  - Test the setup with a simple application or script to ensure everything is functioning as expected.




## T265 connection issue
- **Download, install and run the uhubctl package**
  ```bash
    git clone https://github.com/mvp/uhubctl.git
    cd uhubctl
    make
    make install
    # excute to reboot usb module, launch without the need to remove and re-insert the usb.
    sudo ./uhubctl -a cycle -l 1 -p 1-4
    ```
- The t265 should launch without the need to remove and re-insert the usb
