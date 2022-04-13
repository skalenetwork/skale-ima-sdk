#!/usr/bin/env bash

set -e

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export IMA_SDK_DIR=$DIR/..

COUNTER=0
RETRIES_COUNT=100
SLEEP_TIMEOUT=10

MAINNET_CONTRACTS_ABI_PATH=$IMA_SDK_DIR/contracts_data/proxyMainnet.json
SCHAIN_CONTRACTS_ABI_PATH=$IMA_SDK_DIR/contracts_data/proxySchain_Bob.json

while [ ! -f $MAINNET_CONTRACTS_ABI_PATH ]; do
    echo "Waiting for mainnet contracts $COUNTER/$RETRIES_COUNT";
    if [ $COUNTER -ge $RETRIES_COUNT ]; then
        echo "Contracts wasn't deployed on time :("
        exit 1;
    fi
    COUNTER=$[COUNTER + 1];
    sleep $SLEEP_TIMEOUT;
done
echo "Mainnet contracts deployed: $MAINNET_CONTRACTS_ABI_PATH"

COUNTER=0

while [ ! -f $SCHAIN_CONTRACTS_ABI_PATH ]; do
    echo "Waiting for sChain contracts $COUNTER/$RETRIES_COUNT";
    if [ $COUNTER -ge $RETRIES_COUNT ]; then
        echo "Contracts wasn't deployed on time :("
        exit 1;
    fi
    if [ $COUNTER -ge 50 ]; then
        echo "Contracts deployment taking too much time, printing deployment and skaled logs:"
        echo "------------------------------------------------"
        echo "Deploy logs:"
        tail -n200 $IMA_SDK_DIR/data_dir/all_ima_deploy_sc.txt || true
        echo "------------------------------------------------"
        echo "skaled logs:"
        tail -n200 $IMA_SDK_DIR/data_dir/all_skaled_output.txt || true
    fi
    COUNTER=$[COUNTER + 1];
    sleep $SLEEP_TIMEOUT;
done
echo "sChain contracts deployed: $SCHAIN_CONTRACTS_ABI_PATH"

cp $SCHAIN_CONTRACTS_ABI_PATH $IMA_SDK_DIR/contracts_data/proxySchain.json || sudo cp $SCHAIN_CONTRACTS_ABI_PATH $IMA_SDK_DIR/contracts_data/proxySchain.json
