# Jetson Orin Nano Development Kit NVMe Installation Guide

## Preparing the Device

- **Attaching NVMe:**
  - Attach the NVMe to the Jetson Orin Nano.
  - Remove any SD card in the SD card slot.

- **Entering Recovery Mode:**
  - Turn off the Jetson Orin Nano and disconnect from the power supply.
  - Connect the USB-C end of a USB-A to USB-C or USB-C to USB-C cable to your Orin Nano and the other end to your computer (the one with Jetpack installed).
  - Place a jumper between the FC-REC pin and any GND pin.
  - Reconnect the power supply.

- **Verifying Connection:**
  - On your PC's terminal, type `lsusb`.
  - Confirm that a line appears listing the NVIDIA device.

## Software Installation and Setup

- **Install Nvidia SDK Manager:**
  - Required for flashing.

- **Setting Environment Variable:**
  - Run in terminal:
    ```bash
    export JETPACK=$HOME/nvidia/nvidia_sdk/JetPack_5.1.1_Linux_JETSON_ORIN_NANO_TARGETS/Linux_for_Tegra
    ```
  - Replace the Jetpack version with the version you downloaded.

- **Applying Necessary Commands:**
  - Run in terminal:
    ```bash
    cd $JETPACK  
    sudo ./apply_binaries.sh  
    sudo ./tools/l4t_flash_prerequisites.sh
    ```

- **Flashing on NVMe:**
  - Execute in terminal:
    ```bash
    cd $JETPACK  
    sudo ./tools/kernel_flash/l4t_initrd_flash.sh --external-device nvme0n1p1 \
    -c tools/kernel_flash/flash_l4t_external.xml -p "-c bootloader/t186ref/cfg/flash_t234_qspi.xml" \
    --showlogs --network usb0 jetson-orin-nano-devkit internal
    ```

## Post-Installation Setup

- **Exit Recovery Mode:**
  - Remove the jumper used for entering recovery mode.

- **Reboot the Device:**
  - Follow the prompts to create a username and password.

- **Install CUDA:**
  - Use the following commands:
    ```bash
    sudo apt update  
    sudo apt install cuda-toolkit-11-4
    ```

- **Configure Environment Variables:**
  - Add to `.bashrc`:
    ```bash
    export CUDA_HOME=/usr/local/cuda  
    export PATH=/usr/local/cuda/bin:$PATH   
    export CPATH=/usr/local/cuda/include:$CPATH   
    export LIBRARY_PATH=/usr/local/cuda/lib64:$LIBRARY_PATH  
    export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
    ```



