#!/bin/bash

# Check for docker installation otherwise quit
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Please install docker and try again."
    exit
fi

# Copy service files to correct locations
sudo cp ndntdump-capture-start.service /etc/systemd/system/ndntdump-capture-start.service
sudo cp ndntdump-capture-stop.service /etc/systemd/system/ndntdump-capture-stop.service
sudo cp ndntdump-scp.service /etc/systemd/system/ndntdump-scp.service
sudo cp ndntdump-capture-start.timer /etc/systemd/system/ndntdump-capture-start.timer
sudo cp ndntdump-capture-stop.timer /etc/systemd/system/ndntdump-capture-stop.timer
sudo cp ndntdump-capture-start.sh /usr/local/bin/ndntdump-capture-start.sh
sudo cp ndntdump-capture-stop.sh /usr/local/bin/ndntdump-capture-stop.sh
sudo cp ndntdump-scp.sh /usr/local/bin/ndntdump-scp.sh

# Make necessary files executable
sudo chmod +x /usr/local/bin/ndntdump-capture-start.sh
sudo chmod +x /usr/local/bin/ndntdump-capture-stop.sh
sudo chmod +x /usr/local/bin/ndntdump-scp.sh

# Reload systemd daemon to pick up new files
sudo systemctl daemon-reload

# Check if services are running, stop and disable them if they are
if systemctl is-active --quiet "ndntdump*"; then
    sudo systemctl stop "ndntdump*"
fi
if systemctl is-enabled --quiet "ndntdump-capture-start.timer"; then
    sudo systemctl disable "ndntdump-capture-start.timer"
fi
if systemctl is-enabled --quiet "ndntdump-capture-stop.timer"; then
    sudo systemctl disable "ndntdump-capture-stop.timer"
fi

# Enable and start services
sudo systemctl enable ndntdump-capture-start.timer
sudo systemctl enable ndntdump-capture-stop.timer
sudo systemctl start ndntdump-capture-start.timer
sudo systemctl start ndntdump-capture-stop.timer

echo "Setup complete"