#!/bin/bash

# Pull ndntdump
echo "Pulling ndntdump..."
docker logout
docker pull ghcr.io/usnistgov/ndntdump:latest
docker tag ghcr.io/usnistgov/ndntdump:latest ndntdump:latest

# Start containers
DATE=$(date --utc +"%FT%TZ")
OUT_DIR=/dump

mkdir -p "$OUT_DIR"

IFACE_LIST=$(ip -o link show | awk -F': ' '{print $2}')
for IFACE in $IFACE_LIST; do
    IFACE=$(echo "$IFACE" | sed 's/[^a-zA-Z0-9_-]/-/g')
    if [[ $(docker ps -q -f name=ndntdump-$IFACE) ]]; then
        docker stop ndntdump-$IFACE >/dev/null 2>&1
    fi
    id=$(docker run --network host --name ndntdump-$IFACE -v "$OUT_DIR":/dump --rm -d ndntdump --ifname $IFACE -w "$OUT_DIR/output-$DATE-$IFACE.pcapng.zst")
    echo "Started ndntdump container for interface $IFACE with ID: $id"
done
