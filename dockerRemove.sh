#!/bin/bash
# Install Docker Engine and related components
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
sudo docker --version
#sudo docker-compose --version

echo "change user"
#sudo groupadd docker
#sudo usermod -aG docker $USER

echo "Docker and related components have been installed successfully."
