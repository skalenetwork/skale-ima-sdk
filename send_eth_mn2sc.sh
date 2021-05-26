#!/bin/bash
cd dev_dir/IMA/agent
node ./main.js --verbose=9 --expose --gas-price-multiplier=2 \
    --m2s-payment \
    --ether=2 \
    --url-main-net=$URL_W3_ETHEREUM \
    --url-s-chain=$URL_W3_S_CHAIN \
    --id-main-net=Mainnet \
    --id-s-chain=Bob \
    --cid-main-net=$CHAIN_ID_MAIN_NET \
    --cid-s-chain=$CHAIN_ID_S_CHAIN \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net=$PRIVATE_KEY_FOR_ETHEREUM \
    --address-s-chain=$ACCOUNT_FOR_SCHAIN
cd ../../..