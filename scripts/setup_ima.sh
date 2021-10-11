#!/bin/bash

set -e

: "${IMA_VERSION?Need to set IMA_VERSION}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_IMA_DIR=$DIR/../IMA

if [ ! -d $_IMA_DIR ]; then
    git clone https://github.com/skalenetwork/IMA.git --recursive --recurse-submodules
fi

cd $_IMA_DIR \
    && git reset --hard \
    && git checkout develop \
    && git fetch \
    && git pull \
    && git checkout $IMA_VERSION \
    && cd ..

cp $DIR/../MessageProxyForMainnet.sol $_IMA_DIR/proxy/contracts/mainnet/MessageProxyForMainnet.sol
cp $DIR/../SkaleManagerClient.sol $_IMA_DIR/proxy/contracts/mainnet/SkaleManagerClient.sol