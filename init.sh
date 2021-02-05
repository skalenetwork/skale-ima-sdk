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
        && git checkout dc572cae6f34a9bab1f98d84cba32e5748ac8457 \
        && cp ../../MessageProxyForMainnet.sol ./proxy/contracts/MessageProxyForMainnet.sol \
        && cp ../../LockAndDataForMainnet.sol ./proxy/contracts/LockAndDataForMainnet.sol \
        && yarn install \
        && cd ..
fi

cd ..
