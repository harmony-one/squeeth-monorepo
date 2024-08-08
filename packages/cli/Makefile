ifneq (,$(wildcard .env))
    include .env
    export
endif

mint-and-deposit:
	@forge script ./script/MintAndDeposit.s.sol:MintAndDeposit \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint256,bool)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${MINT_AMOUNT} ${UNI_TOKEN_ID} ${IS_W_AMOUNT}

burn-amount:
	@forge script ./script/BurnAmount.s.sol:BurnAmount \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,bool)" \
	${VAULT_ID} ${BURN_AMOUNT} ${WITHDRAW_AMOUNT} ${IS_W_AMOUNT}

deposit-collateral:
	@forge script ./script/DepositCollateral.s.sol:DepositCollateral \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${UNI_TOKEN_ID}

withdraw-collateral:
	@forge script ./script/WithdrawCollateral.s.sol:WithdrawCollateral \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,bool)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${IS_UNI_TOKEN}

liquidate:
	@forge script ./script/Liquidate.s.sol:Liquidate \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256)" \
	${VAULT_ID} ${MAX_DEBT_AMOUNT}

mint-and-lp:
	@forge script ./script/MintAndLP.s.sol:MintAndLP \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint256,uint256)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${MINT_AMOUNT} ${UNI_TOKEN_ID} ${WETH_AMOUNT}

mint-and-short:
	@forge script ./script/MintAndShort.s.sol:MintAndShort \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint256,uint8)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${MINT_AMOUNT} ${UNI_TOKEN_ID} ${SLIPPAGE}
