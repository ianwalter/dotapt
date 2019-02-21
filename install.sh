#!/bin/bash

# Copy .apt file to home directory.
cp ./.apt ~/.apt

# Update repository cache.
sudo apt update

# Install packages that let apt use packages over HTTPS.
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker GPG key.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository to apt sources.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# Update the package database now that the Docker repo has been added.
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

# Install Linuxbrew.
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

# Add user to docker group.
if [[ $(cat /etc/group | grep docker) == '' ]]; then
  sudo usermod -a -G docker $USER
fi

if [[ ! `which docker-compose` ]]; then
  # Install up-to-date docker-compose.
  sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi
