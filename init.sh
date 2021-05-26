#!/bin/bash

_DATA_DIR="./data_dir"
mkdir -p "${_DATA_DIR}" || true > /dev/null
mkdir -p "${_DATA_DIR}/ipc" || true > /dev/null
mkdir -p "${_DATA_DIR}/node" || true > /dev/null
_DEV_DIR="./dev_dir"
mkdir -p "${_DEV_DIR}" || true > /dev/null

cd ${_DEV_DIR} || exit

if [ ! -d ./IMA ]; then
    git clone https://github.com/skalenetwork/IMA.git --recursive \
        && cd IMA \
        && git checkout develop \
        && git fetch \
        && git pull \
        && git checkout a9c529d405a4041380ed142322473730240c17e5 \
        && cp ../../MessageProxyForMainnet.sol ./proxy/contracts/mainnet/MessageProxyForMainnet.sol \
        && cp ../../SkaleManagerClient.sol ./proxy/contracts/mainnet/SkaleManagerClient.sol \
        && yarn install \
        && cd ..
fi

cd ..
