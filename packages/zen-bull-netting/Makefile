ifneq (,$(wildcard ./.env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

deploy-harmony-testnet:
	@forge script ./script/HarmonyTestnetScript.s.sol --rpc-url https://api.s0.b.hmny.io --private-key $(DEPLOYER_PK) --broadcast --legacy
