#!/bin/bash

# Variables for certificate paths and config
CERT_DIR="/etc/docker/certs"
DOCKER_CONFIG="/etc/docker/daemon.json"
SYSCTL_CONFIG="/etc/sysctl.conf"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 
   exit 1
fi

# Step 1: Disable IPv4 forwarding
echo "Disabling IPv4 forwarding..."
sysctl -w net.ipv4.ip_forward=0

# Remove the IPv4 forwarding line from sysctl.conf if it exists
sed -i '/net.ipv4.ip_forward = 1/d' $SYSCTL_CONFIG

# Step 2: Disable bridge-nf-call-iptables and bridge-nf-call-ip6tables
echo "Disabling bridge-nf-call-iptables and bridge-nf-call-ip6tables..."
sysctl -w net.bridge.bridge-nf-call-iptables=0
sysctl -w net.bridge.bridge-nf-call-ip6tables=0

# Remove these settings from sysctl.conf if they exist
sed -i '/net.bridge.bridge-nf-call-iptables = 1/d' $SYSCTL_CONFIG
sed -i '/net.bridge.bridge-nf-call-ip6tables = 1/d' $SYSCTL_CONFIG

# Step 3: Remove TLS certificates and Docker daemon configuration
echo "Removing Docker TLS certificates and resetting Docker configuration..."

# Remove certificates directory
rm -rf $CERT_DIR

# Reset Docker daemon configuration to default (empty or non-existent)
if [ -f $DOCKER_CONFIG ]; then
    rm $DOCKER_CONFIG
fi

# Step 4: Restart Docker to apply changes
echo "Restarting Docker to apply default configuration..."
systemctl restart docker

# Final message
echo "Docker has been reset to default configuration. Check the logs to ensure everything is back to normal."
journalctl -u docker --since "5 minutes ago
