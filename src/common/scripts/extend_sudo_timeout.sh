#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Backup the current sudoers file
cp /etc/sudoers /etc/sudoers.bak

# Add or modify the timestamp_timeout setting
echo "Defaults timestamp_timeout=3000" | EDITOR='tee -a' visudo

echo "Sudo timeout extended to 3000 minutes."
