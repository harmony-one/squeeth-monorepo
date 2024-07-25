ifneq (,$(wildcard ./.env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

deploy-strategy-harmony-testnet:
	@forge script ./script/HarmonyTestnetDeploy.s.sol --rpc-url https://api.s0.b.hmny.io --private-key $(DEPLOYER_PK) --broadcast --legacy

deploy-withdraw-harmony-testnet:
	@forge script ./script/HarmonyTestnetEmergencyWithdraw.s.sol --rpc-url https://api.s0.b.hmny.io --private-key $(DEPLOYER_PK) --broadcast --legacy
