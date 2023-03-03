#!/bin/bash

while getopts 'i:' flag; do
    case "${flag}" in
        i) IFACE=${OPTARG};;
    esac
done

DATE=$(date +"%Y-%m-%d-%TS")
OUT_DIR="/dump"

mkdir -p $OUT_DIR

docker ps -a -q --filter "name=ndntdump1" | grep -q . && docker stop ndntdump1 && docker rm -fv ndntdump1
docker ps -a -q --filter "name=ndntdump2" | grep -q . && docker stop ndntdump2 && docker rm -fv ndntdump2

id1=$(docker run --network host --name ndntdump1 -v $OUT_DIR:/dump --rm -d ndntdump --ifname ${IFACE} -w $OUT_DIR/output-${DATE}.zst)
sleep 5
id2=$(docker run --network host --name ndntdump2 -v $OUT_DIR:/dump --rm -d ndntdump --ifname lo -w $OUT_DIR/output-ws-${DATE}.zst)