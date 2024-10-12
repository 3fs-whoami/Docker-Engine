#!/bin/bash

# Update package index
sudo apt-get update

# Install necessary packages
sudo apt-get install -y ca-certificates curl

# Create the directory for Docker's keyrings
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

# Set the correct permissions for the GPG key
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again to include Docker packages
sudo apt-get update

# Install Docker Engine and related components
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
sudo docker --version
sudo docker-compose --version

echo "change user"
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Docker and related components have been installed successfully."
