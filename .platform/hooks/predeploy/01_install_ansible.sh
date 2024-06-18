#!/bin/bash

# Update the system
sudo dnf update -y

# Install necessary dependencies
sudo dnf install -y python3 python3-pip python3-devel gcc libffi-devel openssl-devel

# Install Ansible
sudo pip3 install ansible

# Verify the installation
ansible --version
