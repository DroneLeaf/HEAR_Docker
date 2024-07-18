#!/bin/bash


echo "initiate ethernet interface"

# Create or edit the Netplan configuration file for the interface
mkdir -p /etc/netplan
sudo tee /etc/netplan/01-eth-netcfg.yaml > /dev/null <<EOF
network:
  version: 2
  ethernets:
        renderer: networkd
        eth0:
            dhcp4: true
EOF

echo "update eth interface ..."

# Apply the Netplan configuration
sudo netplan apply
