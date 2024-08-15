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

withdraw-lp:
	@forge script ./script/WithdrawLP.s.sol:WithdrawLP \
	--rpc-url $(RPC_URL) --legacy \
	--sig "run(uint256,uint256,uint256)" \
	${TOKEN_ID} ${VAULT_ID} ${WITHDRAW_AMOUNT}

mint-and-short:
	@forge script ./script/MintAndShort.s.sol:MintAndShort \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint256,uint8)" \
	${VAULT_ID} ${COLLATERAL_AMOUNT} ${MINT_AMOUNT} ${UNI_TOKEN_ID} ${SLIPPAGE}

close-short:
	@forge script ./script/CloseShort.s.sol:CloseShort \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint256,uint256,uint8)" \
	${VAULT_ID} ${SHORT_AMOUNT} ${COLLATERAL_WITHDRAW_AMOUNT} ${SLIPPAGE}

open-long:
	@forge script ./script/OpenLong.s.sol:OpenLong \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint8)" \
	${WETH_AMOUNT} ${SLIPPAGE}

close-long:
	@forge script ./script/CloseLong.s.sol:CloseLong \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256,uint8)" \
	${WPOWER_PERP_AMOUNT} ${SLIPPAGE}

crab-deposit:
	@forge script ./script/CrabDeposit.s.sol:CrabDeposit \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256)" \
	${ETH_AMOUNT}

crab-withdraw:
	@forge script ./script/CrabWithdraw.s.sol:CrabWithdraw \
	--rpc-url $(RPC_URL) --legacy --broadcast \
	--sig "run(uint256)" \
	${CRAB_AMOUNT}

trade:
	@forge script ./script/ProfitableTrades.s.sol:ProfitableTrades \
	--rpc-url $(RPC_URL) --legacy --broadcast