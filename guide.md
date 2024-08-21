# Opyn Squeeth Guide

## Harmony Mainnet Addresses

```json
{
  "Oracle": "0xdE82e5Ee59C150f29ac930Ce14AA48014eD4C609",
  "ShortPowerPerp": "0xc388B97694F0dEdbc07Ba41509d2615d997182Fb",
  "WPowerPerp": "0x8dC84d89C96db58D5F7e738DA204F88aaFAEdc9d",
  "SQU/ETH Pool": "0xEB38933823829320cb8d55949cB346fbe1f05429",
  "ETH/USD Pool": "0x6e543B707693492a2D14D729Ac10A9D03B4C9383",
  "ABDKMath64x64": "0xD22Af7Aa8A9F4eD72e1fA75AeB220c98CC18bEd0",
  "TickMathExternal": "0x63C228d52dCBFf09d0A7a4eFd7Fea71A8E18657A",
  "SqrtPriceMathPartial": "0x148B2B8898d989bdaC19a56803379cdB57bCC6D7",
  "Controller": "0x2Eab3378Fe281b3CE16e0f6F4dEb7d47c644A978",
  "ShortHelper": "0x7Fd8d2dE200FfD381a7878b7687e5889bbb999E0",
  "CrabStrategyDeployment": "0x73d413a947834eD2A32AdA1EEFa2e4ca3717C393",
  "ControllerHelperUtil": "0xfB9e8846AB7E094E9db29482E93Da05A737eF598",
  "ControllerHelper": "0xEea0347eD7F20597745Ae828DBC29b62EfebF6c3",
  "CrabStrategyV2": "0x4116c1e672E94742463d26B2E82e6E3b2Eb329A3",
  "CrabHelper": "0xBf8b9Ee781d05A8360280F049179995Af4071B24",
  "ZenBullVault": {
    "ZenBullStrategy": "0xbD429107EEba27caA8A0a135Fb3037B5a0b1f007",
    "ZenEmergencyShutdown": "0x3cb4639063894b5e07823c5e0cd873732087c175",
    "ZenAuction": "0xdab7b3942d392043d0b1c4a6f87a25a70c7ecfa9",
    "FlashZen": "0x135b7d561f1D56935bD55e9c93EABDdCB7b95a08",
    "EmergencyWithdraw": "0xd42fe09e5a5bb0aa2312c9ddd198548f72bde5c5"
  },
  "ZenBullNetting": {
    "NettingLib": "0x4c99979656504f498d71c27ffef95757fe1be682",
    "ZenBullNetting": "0x6a7fe96eb4bb2e33b95d20c0940824ee75e36902"
  }
}
```

## Command Line Interface (CLI)

### Package Link

[GitHub Repository](https://github.com/0x73696d616f/squeeth-monorepo/tree/main/packages/cli)

### Prerequisites

1. Configure the `.env` file:

   - `RPC_URL` - `https://api.s0.t.hmny.io`
   - `PRIVATE_KEY`
   - `CONTROLLER_ADDRESS` - `0x2Eab3378Fe281b3CE16e0f6F4dEb7d47c644A978`
   - `UNI_SWAP_ROUTER_ADDRESS` - `0x88250361E27a3Bf78C0588782B8792d0Bd3A5Ad5`
   - `UNI_NONFUNGIBLE_POSITION_MANAGER_ADDRESS` - `0xE4E259BE9c84260FDC7C9a3629A0410b1Fb3C114`

2. Install Dependencies:

   - Run `forge install`

### Mint and Deposit Script

This script can be used to create a new vault and deposit collateral into it or to deposit collateral into an existing vault.

#### Parameters

- `VAULT_ID`: The ID of the vault. Pass `0` to create a new vault. | _number_
- `COLLATERAL_AMOUNT`: Collateral amount. Not required. | _number_
- `MINT_AMOUNT`: Power perp mint amount. | _number_
- `UNI_TOKEN_ID`: Uniswap v3 position token ID (additional collateral). Pass `0` to skip. | _number_
- `IS_W_AMOUNT`: Set to `"true"` for `wPowerPerp` (non-rebasing) and `"false"` for `powerPerp` (rebasing). | _boolean_

#### Example

To execute a trade that potentially profits from volatility in the underlying asset, use this command:

```bash
make mint-and-deposit VAULT_ID=0 COLLATERAL_AMOUNT=10000000000000000000 MINT_AMOUNT=5000000000000000000 UNI_TOKEN_ID=0 IS_W_AMOUNT=false
```

This command creates a new vault and deposits an initial amount of collateral. The trade can be profitable if the value of the PowerPerp appreciates relative to the collateral cost.

### Burn Amount

Burn a specified power perp amount and remove collateral from the vault.

#### Parameters

- `VAULT_ID`: The ID of the vault. | _number_
- `BURN_AMOUNT`: Burn amount. | _number_
- `WITHDRAW_AMOUNT`: Collateral amount. | _number_
- `IS_W_AMOUNT`: Set to `"true"` for `wPowerPerp` (non-rebasing) and `"false"` for `powerPerp` (rebasing). | _boolean_

#### Example

To close a position and realize a profit after an increase in the PowerPerp's value:

```bash
make burn-amount VAULT_ID=4 WITHDRAW_AMOUNT=9000000000000000000 BURN_AMOUNT=4000000000000000000 IS_W_AMOUNT=false
```

This command burns a specific amount of PowerPerp, and withdraws a set amount of collateral from the vault. It's profitable if the price increase of the PowerPerp offsets the costs of maintaining the position.

### Deposit Additional Collateral

Deposit additional collateral into a vault.

#### Parameters

- `VAULT_ID`: The ID of the vault. | _number_
- `COLLATERAL_AMOUNT`: Collateral amount. | _number_
- `UNI_TOKEN_ID`: Uniswap v3 position token ID. | _number_

#### Example

To strengthen your position during a market dip, ensuring you stay above the minimum collateral requirement:

```bash
make deposit-collateral VAULT_ID=3 COLLATERAL_AMOUNT=1000000000000000000 UNI_TOKEN_ID=0
```

This command deposits more collateral into a vault, allowing for increased exposure or safeguarding against liquidation.

### Withdraw Collateral

Withdraw collateral from a vault.

#### Parameters

- `VAULT_ID`: The ID of the vault. | _number_
- `COLLATERAL_AMOUNT`: Collateral amount. | _number_
- `IS_UNI_TOKEN`: Set to `"true"` for a Uniswap v3 position token and `"false"` for collateral. | _boolean_

#### Example

To realize a profit by reducing exposure when the market conditions are favorable:

```bash
make withdraw-collateral VAULT_ID=3 COLLATERAL_AMOUNT=1000000000000000000 IS_UNI_TOKEN=false
```

This command withdraws collateral, which could be beneficial if the collateral's value has appreciated or if you are taking profits.

### Liquidate Vault

Liquidate a vault. If a vault is under the 150% collateral ratio, anyone can liquidate it by burning `wPowerPerp`.

#### Parameters

- `VAULT_ID`: The ID of the vault. | _number_
- `MAX_DEBT_AMOUNT`: Maximum amount of `wPowerPerp` to repay. | _number_

#### Example

To capitalize on a potential gain from a vault's undercollateralization:

```bash
make liquidate VAULT_ID=3 MAX_DEBT_AMOUNT=10000000
```

This command allows you to liquidate an undercollateralized vault, potentially profiting by acquiring assets at below-market prices due to the forced liquidation.

### Mint And LP

Mint PowerPerp and deposit it into the wSqueeth/WETH pool.

#### Parameters

- `VAULT_ID`: The ID of the vault. Pass `0` to create a new vault. | _number_
- `COLLATERAL_AMOUNT`: Collateral amount. Not required. | _number_
- `MINT_AMOUNT`: Amount of wPowerPerp to mint and provide as liquidity. | _number_
- `UNI_TOKEN_ID`: Uniswap v3 position token ID (additional collateral). Pass `0` to skip. | _number_
- `WETH_AMOUNT`: Amount of WETH to provide as liquidity. | _number_

#### Example

```
make mint-and-lp VAULT_ID=0 COLLATERAL_AMOUNT=10000000000000000000 MINT_AMOUNT=5000000000000000000 UNI_TOKEN_ID=0 WETH_AMOUNT=10000000000000000000
```

### Withdraw LP

Withdraw wSqueeth/WETH pool liquidity and burn wPowerPerp.

#### Parameters

- `TOKEN_ID`: Uniswap v3 position token ID. | _number_
- `VAULT_ID`: The ID of the vault. | _number_
- `WITHDRAW_AMOUNT`: Amount of collateral to withdraw from vault. | _number_

#### Example

```
make withdraw-lp TOKEN_ID=23 VAULT_ID=1 WITHDRAW_AMOUNT=10000000000000000000
```

### Open Long Position

Open a long position by swapping WETH for wPowerPerp.

#### Parameters

- `WETH_AMOUNT` - Amount of WETH to swap for wPowerPerp. | _number_
- `SLIPPAGE` - Maximum slippage percentage. | _number_

#### Example

```
make open-long WETH_AMOUNT=10000000000000000000 SLIPPAGE=20
```

### Open Short Position

Open a short position by swapping wPowerPerp for WETH.

#### Parameters

- `VAULT_ID` - The ID of the vault. Pass `0` to create a new vault. | _number_
- `COLLATERAL_AMOUNT` - Collateral amount. Not required. | _number_
- `MINT_AMOUNT` - Amount of wPowerPerp to mint and swap for WETH. | _number_
- `UNI_TOKEN_ID` - Uniswap v3 position token ID (additional collateral). Pass `0` to skip. | _number_
- `SLIPPAGE` - Maximum slippage percentage. | _number_

#### Example

```
make mint-and-short VAULT_ID=0 COLLATERAL_AMOUNT=10000000000000000000 MINT_AMOUNT=5000000000000000000 UNI_TOKEN_ID=0 SLIPPAGE=10
```

### Close Mint Position

Close a mint position by swapping WETH for wPowerPerp and burning the wPowerPerp.

#### Parameters

- `VAULT_ID` - The ID of the vault. | _number_
- `SHORT_AMOUNT` - Amount of wPowerPerp to burn. | _number_
- `COLLATERAL_WITHDRAW_AMOUNT` - Amount of WETH to withdraw from vault. Not required. | _number_
- `SLIPPAGE` - Maximum slippage percentage. | _number_

#### Example

```
make close-short VAULT_ID=1 SHORT_AMOUNT=5000000000000000000 COLLATERAL_WITHDRAW_AMOUNT=0 SLIPPAGE=20
```

### Close Long Position

Close a long position by swapping wPowerPerp for WETH.

#### Parameters

- `WPOWER_PERP_AMOUNT` - Amount of wPowerPerp to swap for WETH. | _number_
- `SLIPPAGE` - Maximum slippage percentage. | _number_

#### Example

```
make close-long WPOWER_PERP_AMOUNT=5000000000000000000 SLIPPAGE=20
```

### Crab Strategy Deposit

Deposit ETH into the Crab Strategy to mint wSqueeth and strategy token.

#### Parameters

- `ETH_AMOUNT` - Amount of ETH to deposit. | _number_

#### Example

```
make crab-deposit ETH_AMOUNT=10000000000000000000
```

### Crab Strategy Withdraw

Withdraw ETH from the Crab Strategy by burning wSqueeth and strategy token.

#### Parameters

- `CRAB_AMOUNT` - Amount of strategy token to burn. | _number_

#### Example

```
make crab-withdraw CRAB_AMOUNT=10000000000000000000
```

### Profitable Trades

Execute 3 trades, 2 long and 1 short. The first long to close a position, being profitable and the short to as well.

#### Parameters

- `WETH_AMOUNT`: Amount of WETH to provide as liquidity. | _number_
- `BOB_WETH_AMOUNT` - Bob's Amount of WETH to swap for wPowerPerp. | _number_
- `CHARLIE_MINT_AMOUNT` - Charlie's Amount of wPowerPerp to mint and swap for WETH. | _number_
- `DAN_WETH_AMOUNT` - Dan's Amount of WETH to swap for wPowerPerp. | _number_

#### Example

```
make trade WETH_AMOUNT=10000000000000000000 BOB_WETH_AMOUNT=2000000000000000000 CHARLIE_MINT_AM
OUNT=20000000000000000000 DAN_WETH_AMOUNT=20000000000000000000
```
