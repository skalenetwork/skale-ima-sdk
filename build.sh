#!/bin/bash
. ./.env
node ./init_instrument.js
docker build -t skale-ima-sdk:0.0.1 .
# docker build --no-cache -t skale-ima-sdk:latest .
