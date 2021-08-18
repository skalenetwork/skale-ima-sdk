#!/usr/bin/env bash

set -e

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export IMA_SDK_DIR=$DIR/..

cd $IMA_SDK_DIR
docker-compose down

if [ $CLEANUP == 'True' ]; then
    rm -rf $IMA_SDK_DIR/data_dir/
    rm -rf $IMA_SDK_DIR/dev_dir/
    rm -rf $IMA_SDK_DIR/contracts_data/proxyMainnet.json
    rm -rf $IMA_SDK_DIR/contracts_data/proxySchain_Bob.json
    rm -rf $IMA_SDK_DIR/contracts_data/proxySchain.json
fi
