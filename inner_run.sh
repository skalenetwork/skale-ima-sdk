#!/bin/bash
echo " "
echo "Welcome to SKALE IMA SDK container!!!"
echo " "

universal_shutdown_handler()
{
    echo " "
    echo "universal shutdown handler called"
    echo " "
    echo "Stopping IMA agent transfer loop..."
    killall node || true &> /dev/null
    pkill -f node || true &> /dev/null
    echo "Done, IMA stopped"
    echo " "
    echo "Stopping saled..."
    killall skaled || true &> /dev/null
    pkill -f skaled || true &> /dev/null
    sleep 20
    echo "Done, skaled stopped"
}

sigquit()
{
    echo " "
    echo "signal QUIT received"
    unuversal_shutdown_handler
}

sigint()
{
    echo " "
    echo "signal INT received, script ending"
    unuversal_shutdown_handler
    echo " "
    echo "Exitting container..."
    echo " "
    exit 0
}

trap 'sigquit' QUIT
trap 'sigint'  INT
trap ':'       HUP      # ignore the specified signals
echo "Signal handlers were set"


source /dev_dir/.env
echo "NETWORK_FOR_ETHEREUM=${NETWORK_FOR_ETHEREUM}"
echo "NETWORK_FOR_SCHAIN=${NETWORK_FOR_SCHAIN}"
echo "CHAIN_NAME_SCHAIN=${CHAIN_NAME_SCHAIN}"
echo "ACCOUNT_FOR_ETHEREUM=${ACCOUNT_FOR_ETHEREUM}"
echo "ACCOUNT_FOR_SCHAIN=${ACCOUNT_FOR_SCHAIN}"
echo "INSECURE_PRIVATE_KEY_FOR_ETHEREUM=${INSECURE_PRIVATE_KEY_FOR_ETHEREUM}"
echo "INSECURE_PRIVATE_KEY_FOR_SCHAIN=${INSECURE_PRIVATE_KEY_FOR_SCHAIN}"
echo "URL_W3_ETHEREUM=${URL_W3_ETHEREUM}"
echo "URL_W3_S_CHAIN=${URL_W3_S_CHAIN}"
echo " "

echo " "
echo "Will start SKALE Chain..."
export DATA_DIR=/data_dir
SSL_OPTS="--ssl-key /dev_dir/key.pem --ssl-cert /dev_dir/cert.pem"
OUTPUT_OPTS=""
OPTIONS="--no-colors --config /dev_dir/config0.json --db-path=${DATA_DIR} -v 4 --log-value-size-limit 1024000 --performance-timeline-enable --performance-timeline-max-items=16000000 ${SSL_OPTS} ${OUTPUT_OPTS}"
/skaled/skaled ${OPTIONS} &> /data_dir/all_skaled_ouput.txt &
sleep 5
echo "Successfully started SKALE Chain"

if [ ! -f /data_dir/all_ima_deploy_mn.txt ]; then
    echo " "
    echo "Will deploy IMA to Main Net..."
    touch /data_dir/all_ima_deploy_mn.txt
    cd /dev_dir/IMA/proxy || exit
    if [ ! -f /dev_dir/IMA/proxy/data/skaleManagerComponents.json ]; then
        echo '{ "contract_manager_address": "0x0000000000000000000000000000000000000000" }' > /dev_dir/IMA/proxy/data/skaleManagerComponents.json
    fi
    truffle compile &>> /data_dir/all_ima_deploy_mn.txt
    yarn run deploy-to-mainnet &>> /data_dir/all_ima_deploy_mn.txt
    echo "Successfully deployed IMA to Main Net..."
fi

if [ ! -f /data_dir/all_ima_deploy_sc.txt ]; then
    echo " "
    echo "Will deploy IMA to S-Chain..."
    touch /data_dir/all_ima_deploy_sc.txt
    cd /dev_dir/IMA/proxy || exit
    #truffle compile &>> /data_dir/all_ima_deploy_sc.txt
    yarn run deploy-to-schain &>> /data_dir/all_ima_deploy_sc.txt
    echo "Successfully deployed IMA to SKALE Chain..."
fi

if [ ! -f /data_dir/all_ima_registration.txt ]; then
    echo " "
    echo "Will register IMA..."
    touch /data_dir/all_ima_registration.txt
    cd /dev_dir/IMA/agent || exit
    node ./main.js --verbose=9 --gas-price-multiplier=2 \
        --register \
        --url-main-net=$URL_W3_ETHEREUM \
        --url-s-chain=$URL_W3_S_CHAIN \
        --id-main-net=Mainnet \
        --id-s-chain=Bob \
        --cid-main-net=$CHAIN_ID_MAIN_NET \
        --cid-s-chain=$CHAIN_ID_S_CHAIN \
        --abi-main-net=../proxy/data/proxyMainnet.json \
        --abi-s-chain=../proxy/data/proxySchain_Bob.json \
        --key-main-net=$INSECURE_PRIVATE_KEY_FOR_ETHEREUM \
        --key-s-chain=$INSECURE_PRIVATE_KEY_FOR_SCHAIN &>> /data_dir/all_ima_registration.txt
    echo "Successfully registered IMA."
fi

echo " "
echo "Will start IMA agent transfer loop..."
cd /dev_dir/IMA/agent || exit
node ./main.js --verbose=9 --gas-price-multiplier=2 \
    --loop \
    --url-main-net=$URL_W3_ETHEREUM \
    --url-s-chain=$URL_W3_S_CHAIN \
    --id-main-net=Mainnet \
    --id-s-chain=Bob \
    --cid-main-net=$CHAIN_ID_MAIN_NET \
    --cid-s-chain=$CHAIN_ID_S_CHAIN \
    --abi-main-net=../proxy/data/proxyMainnet.json \
    --abi-s-chain=../proxy/data/proxySchain_Bob.json \
    --key-main-net=$INSECURE_PRIVATE_KEY_FOR_ETHEREUM \
    --key-s-chain=$INSECURE_PRIVATE_KEY_FOR_SCHAIN &> /data_dir/all_ima_loop.txt &
echo "Successfully started IMA agent transfer loop"

#
#
#
echo " "
echo "Press any key to stop this docker container"
while [ true ] ; do
    read -t 3 -n 1
    if [ $? = 0 ] ; then
        break # exit ;
    fi
done
#
#
#

echo " "
echo "Stopping IMA agent transfer loop..."
killall node || true &> /dev/null
pkill -f node || true &> /dev/null

echo " "
echo "Stopping skaled..."
killall skaled || true &> /dev/null
pkill -f skaled || true &> /dev/null
sleep 5

universal_shutdown_handler
echo " "
echo "Exitting container..."
echo " "
exit 0