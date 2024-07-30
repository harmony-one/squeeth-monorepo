ifneq (,$(wildcard ./.env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

deploy-strategy-harmony-testnet:
	@forge script ./script/HarmonyTestnetDeploy.s.sol \
	--rpc-url https://api.s0.b.hmny.io --private-key $(DEPLOYER_PK) \
	--broadcast --legacy --sender $(OWNER_ADDRESS)

deploy-strategy-harmony-mainnet:
	@forge script ./script/HarmonyMainnetDeploy.s.sol \
	--rpc-url https://api.s0.t.hmny.io --private-key $(DEPLOYER_PK) \
	--legacy --broadcast --sender $(OWNER_ADDRESS)

deploy-withdraw-harmony-testnet:
	@forge script ./script/HarmonyTestnetEmergencyWithdraw.s.sol \
	--rpc-url https://api.s0.b.hmny.io --private-key $(DEPLOYER_PK) \
	--broadcast --legacy --sender $(OWNER_ADDRESS)

deploy-withdraw-harmony-mainnet:
	@forge script ./script/HarmonyMainnetEmergencyWithdraw.s.sol \
	--rpc-url https://api.s0.t.hmny.io --private-key $(DEPLOYER_PK) \
	--broadcast --legacy --sender $(OWNER_ADDRESS)
