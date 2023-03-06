#!/bin/bash

while getopts 'i:' flag; do
    case "${flag}" in
        i) IFACE=${OPTARG};;
    esac
done

DATE=$(date +"%Y-%m-%d-%TS")
OUT_DIR="/dump"

mkdir -p $OUT_DIR

docker rm -f ndntdump1 2>/dev/null
docker rm -f ndntdump2 2>/dev/null

id1=$(docker run --network host --name ndntdump1 -v $OUT_DIR:/dump --rm -d ndntdump --ifname ${IFACE} -w $OUT_DIR/output-${DATE}.zst)
sleep 5
id2=$(docker run --network host --name ndntdump2 -v $OUT_DIR:/dump --rm -d ndntdump --ifname lo -w $OUT_DIR/output-ws-${DATE}.zst)