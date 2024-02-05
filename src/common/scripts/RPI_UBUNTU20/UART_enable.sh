#!/bin/bash

sudo systemctl stop serial-getty@ttyS0.service
sudo systemctl disable serial-getty@ttyS0.service
sudo systemctl mask serial-getty@ttyS0.service

# sudo nano /etc/udev/rules.d/10-local.rules
# Add this line: KERNEL=="ttyS0", SYMLINK+="serial0" GROUP="tty" MODE="0660"
# And this line: KERNEL=="ttyAMA0", SYMLINK+="serial1" GROUP="tty" MODE="0660"
sudo chown -R $USER /etc/udev/rules.d
sudo echo "KERNEL=="ttyS0", SYMLINK+="serial0" GROUP="tty" MODE="0660"" >> /etc/udev/rules.d/10-local.rules
sudo echo "KERNEL=="ttyAMA0", SYMLINK+="serial1" GROUP="tty" MODE="0660"" >> /etc/udev/rules.d/10-local.rules

sudo udevadm control --reload-rules && sudo udevadm trigger
sudo adduser $USER tty
sudo adduser $USER dialout

# sudo nano /boot/firmware/cmdline.txt
# Delete substring console=serial0,115200
sudo sed -i 's/ console=serial0,115200//' /boot/firmware/cmdline.txt

sudo reboot