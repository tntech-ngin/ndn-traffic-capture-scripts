#!/bin/bash

# Pull ndntdump
echo "Pulling ndntdump..."
docker logout
docker pull ghcr.io/usnistgov/ndntdump:latest
docker tag ghcr.io/usnistgov/ndntdump:latest ndntdump:latest

# Construct node name from site information from nlsr.conf.
# Eg. /edu/memphis gets converted to edu_memphis.
# If infoconv or jq is not installed, or nlsr.conf is not found, use hostname.
NODE=$(hostname)
if command -v infoconv &> /dev/null && command -v jq &> /dev/null && [ -f /etc/ndn/nlsr/nlsr.conf ]; then
    NODE=$(infoconv info2json < /etc/ndn/nlsr/nlsr.conf | jq -r ".general.site" | sed "s/\//_/g")
    NODE=${NODE#_}
fi

DATE=$(date --utc +"%FT%TZ")
OUT_DIR=/home/ndnops/ndntdump-exp-2023
mkdir -p "$OUT_DIR"

docker stop $(docker ps -q -f name=ndntdump-*) > /dev/null 2>&1

# Start container
id=$(docker run --network host --name ndntdump-capture -v "$OUT_DIR":/dump --rm -d ndntdump --ifname "*" -w "/dump/$NODE-$DATE.pcapng.zst")
echo "Started ndntdump container: $id"