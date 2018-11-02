#!/bin/bash

# Copy .apt file to home directory.
cp ./.apt ~/.apt

# Install Homebrew packages from .brew file.
packages=$(brew list)
while read p; do
  installed=$(echo "$packages" | grep -ce "^$p\$")
  if [ $installed == "0" ]; then
    sudo apt install $p
  fi
done < ~/.apt
