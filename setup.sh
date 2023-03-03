#!/bin/bash

# Check if interface name was passed as an argument
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <interface-name>"
    exit 1
fi

# Check if interface exists
if ! ip link show "$1" &> /dev/null; then
  echo "Error: Interface $1 does not exist."
  exit 1
fi

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USER
sudo systemctl start docker

# Pull the latest ndntdump image
echo "Pulling the latest ndntdump image..."
docker pull ghcr.io/usnistgov/ndntdump:latest

# Copy the capture service files to the correct locations
echo "Installing the capture service..."
sudo cp ndntdump-capture.service /etc/systemd/system/ndntdump-capture.service
sudo cp ndn6dump-timer.service /etc/systemd/system/ndntdump-capture.timer
sudo cp start_capture.sh /usr/local/bin/start_capture.sh
sudo cp stop_capture.sh /usr/local/bin/stop_capture.sh
sudo cp ndntdump-capture /usr/local/sbin/ndntdump-capture

# Make the necessary files executable
sudo chmod +x /usr/local/bin/start_capture.sh
sudo chmod +x /usr/local/bin/stop_capture.sh
sudo chmod +x /usr/local/sbin/ndntdump-capture

# Reload the systemd daemon to pick up the new service file
sudo systemctl daemon-reload

# Enable and start the capture service
echo "Enabling and starting the capture services..."
INTERFACE=$1
sudo systemctl enable --now ndntdump-capture.service --now --no-block --show-status -- i $INTERFACE
sudo systemctl enable --now ndntdump-capture.timer

echo "Capture services installed."
