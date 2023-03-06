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
INTERFACE=$1

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y containerd docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo systemctl start docker

# Building ndntdump
echo "Building the latest ndntdump image..."
docker build -t ndntdump 'github.com/usnistgov/ndntdump#main'

# Copy the capture service files to the correct locations
echo "Installing the capture service..."
sudo cp ndntdump-capture-start@.service /etc/systemd/system/ndntdump-capture-start@.service
sudo cp ndntdump-capture-stop@.service /etc/systemd/system/ndntdump-capture-stop@.service
sudo cp ndntdump-capture@.timer /etc/systemd/system/ndntdump-capture@.timer
sudo cp start_capture.sh /usr/local/bin/start_capture.sh
sudo cp stop_capture.sh /usr/local/bin/stop_capture.sh

# Make the necessary files executable
sudo chmod +x /usr/local/bin/start_capture.sh
sudo chmod +x /usr/local/bin/stop_capture.sh

# Reload the systemd daemon to pick up the new service file
sudo systemctl daemon-reload

# Enable and start the capture service
echo "Starting the capture services..."
#sudo systemctl enable ndntdump-capture.service -i $INTERFACE
sudo systemctl start $(systemd-escape --template ndntdump-capture-start@.service "$INTERFACE")
sudo systemctl start $(systemd-escape --template ndntdump-capture@.timer "$INTERFACE")