#!/bin/bash

while getopts 'i:o:' flag; do
    case "${flag}" in
        i) IFACE=${OPTARG};;
        o) OUT_DIR=${OPTARG};;
    esac
done

DATE=$(date +"%Y-%m-%d-%TS")
FILENAME=$(basename $BASH_SOURCE)

echo "$FILENAME"
echo "Network Interface: $IFACE";
echo "Output Dir: $OUT_DIR";
echo "Date: $DATE";

if [[ -z "$IFACE" || -z "$OUT_DIR" ]]; then
    echo "usage: $FILENAME [-i] Interface Name [-o] Output Dir";
    exit 1 ;
fi

mkdir -p $OUT_DIR
docker run --network host --name ndntdump1 -v ${PWD}/dump:${OUT_DIR} --rm -d ndntdump --ifname ${IFACE} -w $OUT_DIR/traffic-capture-${DATE}.zst

#how long does it take this for start up? Need to add sleep and check
if [ "$( docker container inspect -f '{{.State.Running}}' ndntdump1 )" == "true" ]; then 
    docker run --network host --name ndntdump2 -v ${PWD}/dump:$OUT_DIR --rm -d ndntdump --ifname lo -w /dump/output-ws-${DATE}.zst
fi
