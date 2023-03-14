#!/bin/bash

IFACE_LIST=$(ip -o link show | awk -F': ' '{print $2}')
for IFACE in $IFACE_LIST; do
    IFACE=$(echo "$IFACE" | sed 's/[^a-zA-Z0-9_-]/-/g')

    if [[ $(docker ps -q -f name=ndntdump-$IFACE) ]]; then
        docker stop ndntdump-$IFACE >/dev/null 2>&1
    fi
done
sleep 15