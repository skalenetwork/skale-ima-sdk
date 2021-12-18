#!/bin/bash

set -e

export SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
export DIR=$SCRIPTS_DIR/..

cd "$DIR"

node "$DIR/init_instrument.js"

_DATA_DIR=$DIR/data_dir
mkdir -p "${_DATA_DIR}" || true > /dev/null
mkdir -p "${_DATA_DIR}/ipc" || true > /dev/null
mkdir -p "${_DATA_DIR}/node" || true > /dev/null
mkdir -p "${_DATA_DIR}/filestorage" || true > /dev/null

_DEV_DIR=$DIR/dev_dir
mkdir -p "${_DEV_DIR}" || true > /dev/null
cp "$DIR/config0.json" "${_DEV_DIR}/config0.json" || true > /dev/null
cp "$DIR/inner_run.sh" "${_DEV_DIR}/inner_run.sh" || true > /dev/null
cp "$DIR/.env" "${_DEV_DIR}/.env" || true > /dev/null

rm -f "${_DEV_DIR}/*.pem" || true > /dev/null
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout "${_DEV_DIR}/key.pem" -out "${_DEV_DIR}/cert.pem" &> "${_DEV_DIR}/ssl_init_log.txt"

if [ "$NO_NGINX" == 'True' ]; then
    docker-compose up -d sdk ganache
else
    docker-compose up -d
fi

if [ "$WAIT" == 'True' ]; then
    bash "$SCRIPTS_DIR/wait_for_contracts.sh"
fi
