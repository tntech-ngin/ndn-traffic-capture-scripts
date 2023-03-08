#!/bin/bash

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install -y containerd docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
sudo systemctl start docker

# Pull ndntdump
echo "Pulling ndntdump..."
docker logout
docker pull ghcr.io/usnistgov/ndntdump:latest
docker tag ghcr.io/usnistgov/ndntdump:latest ndntdump:latest

# Copy the capture service files to the correct locations
echo "Installing capture services..."
sudo cp ndntdump-capture-start.service /etc/systemd/system/ndntdump-capture-start.service
sudo cp ndntdump-capture-stop.service /etc/systemd/system/ndntdump-capture-stop.service
sudo cp ndntdump-capture.timer /etc/systemd/system/ndntdump-capture.timer
sudo cp start_capture.sh /usr/local/bin/start_capture.sh
sudo cp stop_capture.sh /usr/local/bin/stop_capture.sh

# Make the necessary files executable
sudo chmod +x /usr/local/bin/start_capture.sh
sudo chmod +x /usr/local/bin/stop_capture.sh

# Reload the systemd daemon to pick up the new service file
sudo systemctl daemon-reload

# Enable and start the capture service
echo "Starting capture services..."
sudo systemctl start ndntdump-capture-start.service
sudo systemctl start ndntdump-capture.timer
