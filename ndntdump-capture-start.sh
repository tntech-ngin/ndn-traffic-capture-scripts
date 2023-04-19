#!/bin/bash

# Pull ndntdump
echo "Pulling ndntdump..."
docker logout
docker pull ghcr.io/usnistgov/ndntdump:latest
docker tag ghcr.io/usnistgov/ndntdump:latest ndntdump:latest

# Start containers
DATE=$(date --utc +"%FT%TZ")
NODE=$(hostname)
OUT_DIR=/home/ndnops/ndntdump-exp-2023

mkdir -p "$OUT_DIR"

if [[ $(docker ps -q -f name=ndntdump-$NODE) ]]; then
    docker stop ndntdump-$NODE >/dev/null 2>&1
fi

id=$(docker run --network host --name ndntdump-$NODE -v "$OUT_DIR":/dump --rm -d ndntdump --ifname "*" -w "/dump/output-$NODE-$DATE.pcapng.zst")
echo "Started ndntdump container for interface $IFACE with ID: $id"