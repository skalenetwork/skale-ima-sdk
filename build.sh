#!/bin/bash
. ./.env
node ./init_instrument.js
docker build -t skale-ima-sdk:latest .
