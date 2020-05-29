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

printf "\n✅ Successfully installed Aptitude packages\n\n"
