#!/bin/sh
set -e

while getopts 'u:' flag; do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
    esac
done

FILENAME=$(basename $BASH_SOURCE)
echo "username: $USERNAME";

if [[ -z "$USERNAME" ]]; then
    echo "usage: $FILENAME [-u] USERNAME";
    exit 1 ;
fi

sudo apt update
sudo apt install docker.io
sudo usermod -aG docker $USERNAME
sudo systemclt start docker
docker pull ghcr.io/usnistgov/ndntdump:latest
