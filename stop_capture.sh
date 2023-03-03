#!/bin/bash


while getopts 'o:' flag; do
    case "${flag}" in
        o) OUT_DIR=${OPTARG};;
    esac
done

echo "Output Dir: $OUT_DIR";

if [[ -z "$OUT_DIR" ]]; then
    echo "usage: $FILENAME [-o] Output Dir";
    exit 1 ;
fi



if [ "$( docker container inspect -f '{{.State.Running}}' ndntdump1 )" == "true" ]; then 
    docker stop ndntdump1;
    echo "ndntdump1 stopped";
fi

if [ "$( docker container inspect -f '{{.State.Running}}' ndntdump2 )" == "true" ]; then 
    docker stop ndntdump2
    echo "ndntdump2 stopped";
fi

#upload

scp -J ndntraces@orion.ngin.tntech.edu $OUT_DIR/traffic-capture*.zst ndntraces@10.20.10.30:tracedata/

if [ $? -eq 0 ]; then
   rm $OUT_DIR/*.zst
fi
