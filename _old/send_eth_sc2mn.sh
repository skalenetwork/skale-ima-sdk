#!/bin/bash
cd dev_dir/IMA/agent
node ./main.js --verbose=9 --expose --gas-price-multiplier=2 \
    --s2m-payment \
    --ether=1 \
    --url-main-net=$URL_W3_ETHEREUM \
    --url-s-chain=$URL_W3_S_CHAIN \
    --id-main-net=Mainnet \
    --id-s-chain=Bob \
    --cid-main-net=$CHAIN_ID_MAIN_NET \
    --cid-s-chain=$CHAIN_ID_S_CHAIN \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --address-main-net=$ACCOUNT_FOR_ETHEREUM \
    --key-s-chain=$PRIVATE_KEY_FOR_SCHAIN

sleep 20

node ./main.js --verbose=9 --expose \
    --s2m-view \
    --url-main-net=$URL_W3_ETHEREUM \
    --url-s-chain=$URL_W3_S_CHAIN \
    --id-main-net=Mainnet \
    --cid-main-net=$CHAIN_ID_MAIN_NET \
    --cid-s-chain=$CHAIN_ID_S_CHAIN \
    --id-s-chain=Bob \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net=$PRIVATE_KEY_FOR_ETHEREUM

node ./main.js --verbose=9 --expose --gas-price-multiplier=2 \
    --s2m-receive \
    --url-main-net=$URL_W3_ETHEREUM \
    --url-s-chain=$URL_W3_S_CHAIN \
    --id-main-net=Mainnet \
    --id-s-chain=Bob \
    --cid-main-net=$CHAIN_ID_MAIN_NET \
    --cid-s-chain=$CHAIN_ID_S_CHAIN \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net=$PRIVATE_KEY_FOR_ETHEREUM

cd ../../..