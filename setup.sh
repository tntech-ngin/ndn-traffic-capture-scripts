#!/bin/bash

# Install Docker
sudo apt update
sudo apt install -y containerd docker.io
sudo systemctl enable docker
sudo usermod -aG docker $USER
sudo systemctl start docker

# Copy service files to correct locations
sudo cp ndntdump-capture-start.service /etc/systemd/system/ndntdump-capture-start.service
sudo cp ndntdump-capture-stop.service /etc/systemd/system/ndntdump-capture-stop.service
sudo cp ndntdump-capture.timer /etc/systemd/system/ndntdump-capture.timer
sudo cp ndntdump-capture-start.sh /usr/local/bin/ndntdump-capture-start.sh
sudo cp ndntdump-capture-stop.sh /usr/local/bin/ndntdump-capture-stop.sh
sudo cp ndntdump-scp.sh /usr/local/bin/ndntdump-scp.sh

# Make necessary files executable
sudo chmod +x /usr/local/bin/ndntdump-capture-start.sh
sudo chmod +x /usr/local/bin/ndntdump-capture-stop.sh
sudo chmod +x /usr/local/bin/ndntdump-scp.sh

# Reload systemd daemon to pick up new files
sudo systemctl daemon-reload

# Enable and start services
sudo systemctl enable ndntdump-capture-start.service
sudo systemctl start ndntdump-capture-start.service
sudo systemctl enable ndntdump-capture.timer
sudo systemctl start ndntdump-capture.timer
