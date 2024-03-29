#!/bin/bash

# Stop services
docker stop $(docker ps -q -f name=ndntdump-*) > /dev/null 2>&1
sudo systemctl stop "ndntdump*"
sudo systemctl disable "ndntdump-capture-start.timer"
sudo systemctl disable "ndntdump-capture-stop.timer"

# Remove services
sudo rm /etc/systemd/system/ndntdump-capture-start.service
sudo rm /etc/systemd/system/ndntdump-capture-stop.service
sudo rm /etc/systemd/system/ndntdump-scp.service
sudo rm /etc/systemd/system/ndntdump-capture-start.timer
sudo rm /etc/systemd/system/ndntdump-capture-stop.timer
sudo rm /usr/local/bin/ndntdump-capture-start.sh
sudo rm /usr/local/bin/ndntdump-capture-stop.sh
sudo rm /usr/local/bin/ndntdump-scp.sh

# Reload systemd daemon
sudo systemctl daemon-reload

echo "Uninstall complete"