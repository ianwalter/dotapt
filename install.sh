#!/bin/bash

# Copy .apt file to home directory.
cp ./.apt ~/.apt

# Update repository cache.
sudo apt update

# Install Aptitude packages from .apt file.
packages=$(apt list --installed 2>/dev/null | awk -F'/' 'NR>1{print $1}')
while read p; do
  installed=$(echo "$packages" | grep -ce "^$p\$")
  if [ $installed == "0" ]; then
    sudo apt install -y $p
  fi
done < ~/.apt

# Copy .snapfile file to home directory.
cp ./.snapfile ~/.snapfile

# Install Snapcraft packages from .snap file.
packages=$(snap list)
while read p; do
  installed=$(echo "$packages" | grep -ce "^$p\$")
  if [ $installed == "0" ]; then
    sudo snap install $p
  fi
done < ~/.snapfile

# Add user to docker group.
if [[ $(cat /etc/group | grep docker) == '' ]]; then
  sudo usermod -a -G docker $USER
fi
