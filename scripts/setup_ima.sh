#!/bin/bash

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_IMA_DIR=$DIR/IMA

if [ ! -d $_IMA_DIR ]; then
    git clone https://github.com/skalenetwork/IMA.git --recursive --recurse-submodules \
        && cd $_IMA_DIR \
        && git checkout develop \
        && git fetch \
        && git pull \
        && git checkout 1.0.0-stable.0 \
        && cp $DIR/MessageProxyForMainnet.sol $_IMA_DIR/proxy/contracts/mainnet/MessageProxyForMainnet.sol \
        && cp $DIR/SkaleManagerClient.sol $_IMA_DIR/proxy/contracts/mainnet/SkaleManagerClient.sol \
        && cd ..
fi