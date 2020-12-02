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
        && git checkout 3b1a68275318293608744c13ffc4462ac3530b03 \
        && cp ../../MessageProxyForMainnet.sol ./proxy/contracts/MessageProxyForMainnet.sol \
        && cp ../../LockAndDataForMainnet.sol ./proxy/contracts/LockAndDataForMainnet.sol \
        && yarn install \
        && cd ..
fi

cd ..
