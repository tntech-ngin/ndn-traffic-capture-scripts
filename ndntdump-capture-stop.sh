#!/bin/bash

NODE=$(hostname)

if [[ $(docker ps -q -f name=ndntdump-$NODE) ]]; then
    docker stop ndntdump-$NODE >/dev/null 2>&1
fi