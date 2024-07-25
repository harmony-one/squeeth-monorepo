# Define a helper function to read .env variables
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Define the target
deploy-harmony-testnet:
	npx hardhat deploy --network harmonyTestnet
