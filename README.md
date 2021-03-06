# SKALE IMA SDK

[![Discord](https://img.shields.io/discord/534485763354787851.svg)](https://discord.gg/vvUtWJB)

This repo provides a SDK for running IMA on a single-node SKALE chain. This SDK operates without BLS signature verification.

## Prerequisites

* gcc/g++ 7
* Docker
* nodejs v10.X
* yarn
* truffle@5.0.12

On Ubuntu:

```shell
sudo apt-get update && add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get install -y apt-utils \
    build-essential \
    docker.io \
    g++-7 \
    gcc-7 \
    make  && \
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 \
        --slave /usr/bin/g++ g++ /usr/bin/g++-7 && \
    sudo update-alternatives --config gcc && \
    gcc --version && \
    g++ --version

# Install Nodejs, yarn

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
    sudo apt-get install -y nodejs && \
    node --version && \
    npm --version && \
    sudo npm install -g yarn && \
    yarn --version

# Install Truffle

sudo npm install --unsafe-perm -g truffle@5.0.12
truffle --version
```

## Clone this repo

```shell
git clone https://github.com/skalenetwork/skale-ima-sdk.git
cd skale-ima-sdk
```

## Configuration

By default, basic provided configuration uses Rinkeby. This can be changed by editing `.env` file and providing alternative **Ethereum** URL pointing to other network like local ganache. Negative value `-4` should be specified in the `CHAIN_ID_MAIN_NET` variable for local ganache network. 

## Setup

Modify environment variables in the .env file and load.

```shell
source .env
```

Install all required parts and source code:

```shell
./init.sh
```

Build the docker container:

```shell
./build.sh
```

## Run

To run IMA with Rinkeby:

```shell
script /dev/null
screen -S IMA-SKALE-Chain-Box -d -m bash -c "./run.sh"
```

## Access ABIs

The ABIs geenerated for the IMA smart contracts deployed to mainnet/testnet and the SKALE Chain can be found in the following folder:

```shell

cd skale-ima-sdk/dev_dir/IMA/proxy/data/

```
  Mainnet ABI: `proxyMainnet.json` 
  SKALE Chain ABI: `proxySchain_Bob.json`

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