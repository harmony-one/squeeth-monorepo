ifneq (,$(wildcard .env))
    include .env
    export
endif

mint-and-deposit:
	@forge script ./script/MintAndDeposit.s.sol:MintAndDeposit \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint256,bool)" \
	${VAULT_ID} ${COLL_AMOUNT} ${AMOUNT} ${UNI_TOKEN_ID} ${IS_W_AMOUNT}

burn-amount:
	@forge script ./script/BurnAmount.s.sol:BurnAmount \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,bool)" \
	${VAULT_ID} ${POWER_PERP_AMOUNT} ${WITHDRAW_AMOUNT} ${IS_W_AMOUNT}

deposit-collateral:
	@forge script ./script/DepositCollateral.s.sol:DepositCollateral \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256)" \
	${VAULT_ID} ${COLL_AMOUNT} ${UNI_TOKEN_ID}

withdraw-collateral:
	@forge script ./script/WithdrawCollateral.s.sol:WithdrawCollateral \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,bool)" \
	${VAULT_ID} ${COLL_AMOUNT} ${IS_UNI_TOKEN}

liquidate:
	@forge script ./script/Liquidate.s.sol:Liquidate \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256)" \
	${VAULT_ID} ${MAX_DEBT_AMOUNT}
