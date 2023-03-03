#!/bin/bash

echo "Stopping containers..."
docker ps -q --filter "name=ndntdump1" | grep -q . && docker stop ndntdump1 && docker rm -fv ndntdump1
docker ps -q --filter "name=ndntdump2" | grep -q . && docker stop ndntdump2 && docker rm -fv ndntdump2