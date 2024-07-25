// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";

import { IERC20 } from "openzeppelin/token/ERC20/IERC20.sol";
import { EmergencyWithdraw } from "../src/EmergencyWithdraw.sol";


contract MainnetDeployEmergencyWithdraw is Script {
    address payable public constant ZEN_BULL = 0x9bAD58c14B0b00bb7A48d3F089Fd58778294ad32;
    address public constant WETH = 0x67142ed6CF29B07138fca14fD306f9308D63D09f;
    address public constant CRAB = 0x9a9A498f8D10a5De282B15428429a3F6DCC79BeB; // CrabStrategyV2
    address public constant UNI_FACTORY = 0x14d34078f68d07859CF57B25785B923c443DaE71;
    address public constant WPOWERPERP = 0xAecdB1d109183832053ca9710EC1dB8E0523A96E;
    address public constant ETH_USDC_POOL = 0x369F2326c3DaA2F8e53D6d4A90883a3d35792416; // WETH_USDC
    address public constant USDC = 0xa1e1f6E12f9Ccd7a1A66a0332A419Bf2a39D3db5;
    address public constant E_TOKEN = 0xA8737E49525bE492894A042586e024dFb25ECeD0; // eWETH
    address public constant D_TOKEN = 0x527E0c74F6Cf0f0122FB6584447fBd29b58e5bA3; // dUSDC

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
