#!/bin/bash
. ./.env
node ./init_instrument.js
docker build --no-cache -t skale-ima-sdk:latest .
# docker build -t skale-ima-sdk:latest .
