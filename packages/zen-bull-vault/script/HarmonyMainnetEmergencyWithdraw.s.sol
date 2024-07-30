// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";

import { IERC20 } from "openzeppelin/token/ERC20/IERC20.sol";
import { EmergencyWithdraw } from "../src/EmergencyWithdraw.sol";


contract HarmonyMainnetDeployEmergencyWithdraw is Script {
    address payable public constant ZEN_BULL = 0xbD429107EEba27caA8A0a135Fb3037B5a0b1f007;
    address public constant WETH = 0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a;
    address public constant CRAB = 0x4116c1e672E94742463d26B2E82e6E3b2Eb329A3; // CrabStrategyV2
    address public constant UNI_FACTORY = 0x12d21f5d0Ab768c312E19653Bf3f89917866B8e8;
    address public constant WPOWERPERP = 0x8dC84d89C96db58D5F7e738DA204F88aaFAEdc9d;
    address public constant ETH_USDC_POOL = 0x6e543B707693492a2D14D729Ac10A9D03B4C9383; // WETH_USDC
    address public constant USDC = 0xBC594CABd205bD993e7FfA6F3e9ceA75c1110da5;
    address public constant E_TOKEN = 0x37EdBd95fCFD212299B4E1Ef40d526292B15951d; // eWETH
    address public constant D_TOKEN = 0x07e0fD258186281485f5807F2f6D51f4CA15a8c9; // dUSDC

    // Deploy contracts
    EmergencyWithdraw emergencyWithdraw;

    function run() public {
        uint256 deployerKey = vm.envUint("DEPLOYER_PK");
        address deployerAddress = vm.rememberKey(deployerKey);

        vm.startBroadcast(deployerAddress);

        emergencyWithdraw =
        new EmergencyWithdraw(CRAB, ZEN_BULL, WETH, USDC, WPOWERPERP, ETH_USDC_POOL, E_TOKEN, D_TOKEN, UNI_FACTORY);

        vm.stopBroadcast();

        require(emergencyWithdraw.redeemedZenBullAmountForCrabWithdrawal() == 0);
        require(emergencyWithdraw.redeemedRecoveryAmountForEulerWithdrawal() == 0);
    }
}
