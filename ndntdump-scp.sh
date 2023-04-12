#!/bin/bash

OUTPUT_DIR=/home/ndnops/ndntdump-exp-2023

scp -oProxyJump=ndntraces@orion.ngin.tntech.edu ${OUTPUT_DIR}/output-*.zst ndntraces@10.20.10.30:/raid/tracedata/

if [ $? -eq 0 ]; then
    rm -rf ${OUTPUT_DIR}
fi
