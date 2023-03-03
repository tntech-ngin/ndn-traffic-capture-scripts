#!/bin/bash


if [ "$( docker container inspect -f '{{.State.Running}}' ndntdump1 )" == "true" ]; then 
    docker stop ndntdump1;
    echo "ndntdump1 stopped";
fi

if [ "$( docker container inspect -f '{{.State.Running}}' ndntdump2 )" == "true" ]; then 
    docker stop ndntdump2
    echo "ndntdump2 stopped";
fi

