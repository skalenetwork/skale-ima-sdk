#!/bin/bash

_IMAGE_TO_RUN="skale-ima-sdk:latest"

_DATA_DIR="./data_dir"
mkdir -p "${_DATA_DIR}" || true > /dev/null
_DEV_DIR="./dev_dir"
mkdir -p "${_DEV_DIR}" || true > /dev/null
cp ./config0.json "${_DEV_DIR}/config0.json" || true > /dev/null
cp ./inner_run.sh "${_DEV_DIR}/inner_run.sh" || true > /dev/null
cp ./.env "${_DEV_DIR}/.env" || true > /dev/null

rm -f ${_DEV_DIR}/*.pem || true > /dev/null
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout ${_DEV_DIR}/key.pem -out ${_DEV_DIR}/cert.pem &> ${_DEV_DIR}/ssl_init_log.txt

_args_arr=""
_args_arr="${_args_arr} -p 15000:15000 -p 15010:15010 -p 15020:15020 -p 15030:15030 -p 15040:15040 -p 15050:15050"

docker run --network=host -v $(pwd)/${_DATA_DIR}:/data_dir -v $(pwd)/${_DEV_DIR}:/dev_dir ${_args_arr} --stop-timeout 40 -i -t ${_IMAGE_TO_RUN}