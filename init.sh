#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

_DATA_DIR=$DIR/data_dir
mkdir -p "${_DATA_DIR}" || true > /dev/null
mkdir -p "${_DATA_DIR}/ipc" || true > /dev/null
mkdir -p "${_DATA_DIR}/node" || true > /dev/null

_DEV_DIR=$DIR/dev_dir
mkdir -p "${_DEV_DIR}" || true > /dev/null

cd ${_DEV_DIR} || exit

if [ ! -d ./IMA ]; then
    git clone https://github.com/skalenetwork/IMA.git --recursive --recurse-submodules \
        && cd $_DEV_DIR/IMA \
        && git checkout develop \
        && git fetch \
        && git pull \
        && git checkout 1.0.0-stable.0 \
        && cp $DIR/MessageProxyForMainnet.sol $_DEV_DIR/IMA/proxy/contracts/mainnet/MessageProxyForMainnet.sol \
        && cp $DIR/SkaleManagerClient.sol $_DEV_DIR/IMA/proxy/contracts/mainnet/SkaleManagerClient.sol \
        && cd ..
fi

cd ..
