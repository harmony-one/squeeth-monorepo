# Deployment Notes

**Foundry Version:** forge 0.2.0 (fdfaafd62 2024-07-29T18:19:48.848723000Z)  
**Node Version:** v18.20.0

1. Install dependencies using `npm install`.

2. Navigate to the `hardhat` package:
   1. Configure the `.env` file. For the deployment of the contracts, only `PRIVATE_KEY` is required.
   2. Deploy contracts using `make deploy-harmony-mainnet` or `make deploy-harmony-testnet`.

3. Navigate to the `zen-bull-vault` package:
   1. Configure the `.env` file. For the deployment of the contracts, only `PRIVATE_KEY` and `OWNER_ADDRESS` are required.
   2. Install dependencies using `forge install`.
   3. Deploy contracts using `deploy-strategy-harmony-testnet`, `deploy-strategy-harmony-mainnet`, `deploy-withdraw-harmony-testnet`, `deploy-withdraw-harmony-mainnet`.

4. Navigate to the `zen-bull-netting` package:
   1. Configure the `.env` file. For the deployment of the contracts, only `PRIVATE_KEY` and `OWNER_ADDRESS` are required.
   2. Install dependencies using `forge install`.
   3. Deploy contracts using `make deploy-harmony-mainnet` or `make deploy-harmony-testnet`.

5. Navigate to the `cli` package:
   1. Configure the `.env` file.
   2. Install dependencies using `forge install`.
   3. Use `make` scripts to interact with the protocol.