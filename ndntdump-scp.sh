#!/bin/bash

OUTPUT_DIR=/home/ndnops/ndntdump-exp-2023

scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oProxyCommand="ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -W %h:%p ndntraces@orion.ngin.tntech.edu" ${OUTPUT_DIR}/*.zst ndntraces@10.20.10.30:/raid/tracedata/

if [ $? -eq 0 ]; then
  sudo rm -rf ${OUTPUT_DIR} # need sudo, dir is owned by root
fi
