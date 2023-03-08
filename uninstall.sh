#!/bin/bash

# Stop services
sudo systemctl stop "ndntdump*"

# Remove services
sudo rm /etc/systemd/system/ndntdump-capture-start.service
sudo rm /etc/systemd/system/ndntdump-capture-stop.service
sudo rm /etc/systemd/system/ndntdump-capture.timer
sudo rm /usr/local/bin/start_capture.sh
sudo rm /usr/local/bin/stop_capture.sh

# Reload systemd daemon
sudo systemctl daemon-reload
echo "Uninstalled capture services"
