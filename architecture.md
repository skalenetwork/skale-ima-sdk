# SKALE IMA SDK architecture

This document will describe new IMA-SDK architecture that allows:

1. Multiple chains on the same machine (2 in the default setup)
2. Usage of all predeployed libs in the same way as in the skale-admin (ima, filestorage, etherbase, etc) to extend use-cases for IMA-SDK (it can be new SKALE-SDK)
3. Chain to chain IMA transfers (multiple IMA agents)

## Reasoning

The current architecture of the IMA-SDK makes it impossible to implement a sandbox environment for s2s IMA transfers which might be really helpful for dApp devs and also will be used for IMA-JS tests.

## New architecture

IMA SDK architecture should will include:

1. `sdk_admin` container that will run all other dynamic containers
2. `ganache` container as a 'Mainnet'
3. Dynamic containers: `ima` and `schain` (2 for each schain)

### Runtime actions

1. Run `sdk_admin` and `ganache` containers (docker-compose), then deploy Mainnet parts of the system - `helper-scripts` will be used.
2. `sdk_admin` container waits till contracts will be deployed on the Mainnet side, then will generate configs for all chains
3. `sdk_admin` will run `schain` and `ima` containers for each chain (owner is PK) - all contracts will be predeployed



