#!/bin/bash

# Stop services
sudo systemctl stop "ndntdump*"

# Remove services
sudo rm /etc/systemd/system/ndntdump-capture-start.service
sudo rm /etc/systemd/system/ndntdump-capture-stop.service
sudo rm /etc/systemd/system/ndntdump-capture-start.timer
sudo rm /etc/systemd/system/ndntdump-capture-stop.timer
sudo rm /usr/local/bin/ndntdump-capture-start.sh
sudo rm /usr/local/bin/ndntdump-capture-stop.sh
sudo rm /usr/local/bin/ndntdump-scp.sh

# Reload systemd daemon
sudo systemctl daemon-reload
