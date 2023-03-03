#!/bin/bash

# Stop and disable the capture service
echo "Uninstalling capture service..."
sudo systemctl stop "ndntdump-capture@*.service"
sudo systemctl stop ndntdump-capture.timer

# Remove the capture service files
echo "Removing capture service files..."
sudo rm /etc/systemd/system/ndntdump-capture@.service
sudo rm /etc/systemd/system/ndntdump-capture.timer
sudo rm /usr/local/bin/start_capture.sh
sudo rm /usr/local/bin/stop_capture.sh

# Reload the systemd daemon
sudo systemctl daemon-reload

echo "Capture service uninstalled."