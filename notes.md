# Deployment Notes

**Foundry Version:** forge 0.2.0 (fdfaafd62 2024-07-29T18:19:48.848723000Z)  
**Node Version:** v18.20.0

1. Install dependencies using `npm install`.

2. Navigate to the `hardhat` package:
   1. Configure the `.env` file. See `.env.example` for the required environment variables. For the deployment of the contracts, only `PRIVATE_KEY` is required.
   2. Deploy contracts using `make deploy-harmony-mainnet` or `make deploy-harmony-testnet`.

3. Navigate to the `zen-bull-vault` package:
   1. Configure the `.env` file. See `.env.example` for the required environment variables. For the deployment of the contracts, only `PRIVATE_KEY` and `OWNER_ADDRESS` are required.
   2. Install dependencies using `forge install`.
   3. Deploy contracts using `deploy-strategy-harmony-testnet`, `deploy-strategy-harmony-mainnet`, `deploy-withdraw-harmony-testnet`, `deploy-withdraw-harmony-mainnet`.

4. Navigate to the `zen-bull-netting` package:
   1. Configure the `.env` file. See `.env.example` for the required environment variables. For the deployment of the contracts, only `PRIVATE_KEY` and `OWNER_ADDRESS` are required.
   2. Install dependencies using `forge install`.
   3. Deploy contracts using `make deploy-harmony-mainnet` or `make deploy-harmony-testnet`.

5. Navigate to the `cli` package:
   1. Configure the `.env` file. See `.env.example` for the required environment variables.
   1.1 `UNI_SWAP_ROUTER_ADDRESS` - The address of the Uniswap Router.
   1.2 `UNI_NONFUNGIBLE_POSITION_MANAGER_ADDRESS` - The address of the Uniswap Nonfungible Position Manager.
   1.3 `CONTROLLER_ADDRESS` - The address of the Squeeth Controller contract.
   1.4 `RPC_URL` - The RPC URL of the Harmony network.
   1.5 `PRIVATE_KEY` - The private key of the account that will interact with the contracts.
   1. Install dependencies using `forge install`.
   2. Use `make` scripts to interact with the protocol.