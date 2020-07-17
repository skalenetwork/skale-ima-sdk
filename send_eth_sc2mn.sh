#!/bin/bash
cd dev_dir/IMA/agent || exit
node ./main.js --verbose=9 --gas-price-multiplier=2 \
    --s2m-payment \
    --ether=1 \
    --url-main-net="$URL_W3_MAIN_NET" \
    --url-s-chain="$URL_W3_S_CHAIN" \
    --id-main-net="$NETWORK_FOR_MAINNET" \
    --id-s-chain="$CHAIN_NAME_SCHAIN" \
    --cid-main-net="$CHAIN_ID_MAIN_NET" \
    --cid-s-chain="$CHAIN_ID_S_CHAIN" \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --address-main-net="$ACCOUNT_FOR_MAIN_NET" \
    --key-s-chain="$PRIVATE_KEY_FOR_SCHAIN"

sleep 20

node ./main.js --verbose=9 \
    --s2m-view \
    --url-main-net="$URL_W3_MAIN_NET" \
    --url-s-chain="$URL_W3_S_CHAIN" \
    --id-main-net="$NETWORK_FOR_MAINNET" \
    --cid-main-net="$CHAIN_ID_MAIN_NET" \
    --cid-s-chain="$CHAIN_ID_S_CHAIN" \
    --id-s-chain="$CHAIN_NAME_SCHAIN" \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net="$PRIVATE_KEY_FOR_MAINNET"

node ./main.js --verbose=9 --gas-price-multiplier=2 \
    --s2m-receive \
    --url-main-net="$URL_W3_MAIN_NET" \
    --url-s-chain="$URL_W3_S_CHAIN" \
    --id-main-net="$NETWORK_FOR_MAINNET" \
    --id-s-chain="$CHAIN_NAME_SCHAIN" \
    --cid-main-net="$CHAIN_ID_MAIN_NET" \
    --cid-s-chain="$CHAIN_ID_S_CHAIN" \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net="$PRIVATE_KEY_FOR_MAINNET"

cd ../../..
