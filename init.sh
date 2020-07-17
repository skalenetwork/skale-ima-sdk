#!/bin/bash

_DATA_DIR="./data_dir"
mkdir -p "${_DATA_DIR}" || true > /dev/null
_DEV_DIR="./dev_dir"
mkdir -p "${_DEV_DIR}" || true > /dev/null

cd ${_DEV_DIR} || exit

if [ ! -d ./IMA ]; then
    git clone https://github.com/skalenetwork/IMA.git --recursive \
        && cd IMA \
        && cp ../../MessageProxyForMainnet.sol ./proxy/contracts/MessageProxyForMainnet.sol \
        && yarn install \
        && cd ..
fi

cd ..
