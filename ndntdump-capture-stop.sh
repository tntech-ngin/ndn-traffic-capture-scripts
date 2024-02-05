#!/bin/bash

docker stop $(docker ps -q -f name=ndntdump-*) > /dev/null 2>&1