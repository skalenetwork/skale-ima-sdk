# SKALE IMA SDK

[![Discord](https://img.shields.io/discord/534485763354787851.svg)](https://discord.gg/vvUtWJB)

This repo provides a SDK for running IMA on a single-node SKALE chain. This SDK operates without BLS signature verification.

## Usage guide

### Prerequisites

* Docker
* docker-compose
* nodejs (any version)

1. Clone this repo
2. Copy .env template and fill variables:

```bash
cp .env-compose-sample .env
nano .env
```

3. Export environment variables:

```bash
export $(grep -v '^#' .env | xargs)
```

4. Put SSL cert & key to `ssl` folder (names should be `ssl_key` and `ssl_cert`):

*This step is optional*
*You should have SSL certs and setup redirects by yourself*

```bash
cp privkey.pem ~/skale-ima-sdk/ssl/ssl_key
cp cert.pem ~/skale-ima-sdk/ssl/ssl_cert
```

5. Execute to run SDK and deploy contracts:

```bash
WAIT=True bash scripts/run_sdk.sh
```

Now sChain and Mainnet parts are available:

```bash
# sChain
http://$IP_ADDRESS:15000
http://$DOMAIN_NAME/schain # if you have SSL certs and domain name
https://$DOMAIN_NAME/schain # if you have SSL certs and domain name

# Mainnet
http://$IP_ADDRESS:1545
http://$DOMAIN_NAME/mainnet # if you have SSL certs and domain name
https://$DOMAIN_NAME/mainnet # if you have SSL certs and domain name
```

When you're done, stop SDK:

```bash
CLEANUP=True  bash scripts/stop_sdk.sh
```

## Helpful info

### Pass additional accounts

You can pass any number of additional accounts to the SDK.  
All accounts will have pre-allocated ETH both on Mainnet and sChain sides.
  
To do that add `additional_accounts.json` file in the root of the project. Structure of the file:

```json
[
    {
        "private_key": "0x...",
        "address": "0x.."
    },
    {
        "private_key": "0x...",
        "address": "0x.."
    }
    ...
]
```

### Install Nodejs

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    node --version

### Clone this repo

```bash
git clone https://github.com/skalenetwork/skale-ima-sdk.git
cd skale-ima-sdk
```

## Access ABIs

The ABIs generated for the IMA smart contracts deployed to mainnet/testnet and the SKALE Chain can be found in the following folder:

```bash
skale-ima-sdk/contracts_data/proxyMainnet.json # Mainnet part
skale-ima-sdk/contracts_data/proxySchain_Bob.json # sChain part
```

## Development

Init repo for development

```bash
bash scripts/setup_ima.sh
```

Build and publish image:

```bash
DOCKER_USERNAME= DOCKER_PASSWORD= CONTAINER_NAME=ima_sdk BRANCH=develop VERSION=0.0.0 bash helper-scripts/build_and_publish.sh 
```

## Troubleshooting

```shell
tail -f data_dir/all_ima_deploy_mn.txt      # Monitor IMA Mainnet deployment
tail -f data_dir/all_ima_deploy_sc.txt      # Monitor IMA SKALE Chain deployment
tail -f data_dir/all_ima_registration.txt   # Monitor IMA registration
tail -f data_dir/all_ima_loop.txt           # Monitor IMA agent

./clean.sh                                  # Remove data files for rebuild
docker ps                                   # Show running containers
docker stop [NAMES]                         # Stop container before rebuilding
```

Reach out to the developer community on Discord: [![Discord](https://img.shields.io/discord/534485763354787851.svg)](https://discord.gg/vvUtWJB)

[![License](https://img.shields.io/github/license/skalenetwork/skale-ima-sdk.svg)](LICENSE)

All contributions are made under the [GNU Affero General Public License v3](https://www.gnu.org/licenses/agpl-3.0.en.html). See [LICENSE](LICENSE).

Copyright (C) 2020-present SKALE Labs
