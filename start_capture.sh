#!/bin/bash

while getopts 'i:' flag; do
    case "${flag}" in
        i) IFACE=${OPTARG};;
    esac
done

DATE=$(date +"%Y-%m-%d-%TS")
OUT_DIR="/dump"
mkdir -p $OUT_DIR
docker run --network host --name ndntdump1 -v ${PWD}/dump:${OUT_DIR} --rm -d ndntdump --ifname ${IFACE} -w $OUT_DIR/output-${DATE}.zst
docker run --network host --name ndntdump2 -v ${PWD}/dump:$OUT_DIR --rm -d ndntdump --ifname lo -w $OUT_DIR/output-ws-${DATE}.zst