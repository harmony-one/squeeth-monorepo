// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import { DeployScript } from "./Deploy.s.sol";

contract HarmonyTestnetDeploy is DeployScript {
    address public constant systemOwnerAddress = 0xD78731472512ddAb457bD64d027e1BBc2Ce4aBC0;
    address public constant auctionManagerAddress = 0xD78731472512ddAb457bD64d027e1BBc2Ce4aBC0;
    address public constant crabAddress = 0x9a9A498f8D10a5De282B15428429a3F6DCC79BeB; // CrabStrategyV2 
    address public constant powerTokenControllerAddress = 0x1bB7fBfb24388226c85B602660Af23301995577e; // Controller
    address public constant eulerAddress = 0xf657D9cB1284d72F4bac0d5006B9C0Ac38B0f00d;
    address public constant eulerMarketsModuleAddress = 0xAa7E572dbA730878478B6c808F5FFA6fa893d43D;
    address public constant uniFactoryAddress = 0x14d34078f68d07859CF57B25785B923c443DaE71;
    address public constant eTokenAddress = 0xA8737E49525bE492894A042586e024dFb25ECeD0; // eWETH
    address public constant dTokenAddress = 0x527E0c74F6Cf0f0122FB6584447fBd29b58e5bA3; // dUSDC
    uint256 public constant bullStrategyCap = 400e18;
    uint256 public constant fullRebalancePriceTolerance = 0.05e18;
    uint256 public constant rebalanceWethLimitPriceTolerance = 0.05e18;
    uint256 public constant crUpper = 2.2e18;
    uint256 public constant crLower = 1.8e18;
    uint256 public constant deltaUpper = 1.1e18;
    uint256 public constant deltaLower = 0.9e18;

    constructor() {
        setAddressParamsAtConstructor(
            systemOwnerAddress,
            auctionManagerAddress,
            crabAddress,
            powerTokenControllerAddress,
            eulerAddress,
            eulerMarketsModuleAddress,
            uniFactoryAddress,
            eTokenAddress,
            dTokenAddress
        );

        setUintParamsAtConstructor(
            bullStrategyCap,
            fullRebalancePriceTolerance,
            rebalanceWethLimitPriceTolerance,
            crUpper,
            crLower,
            deltaUpper,
            deltaLower
        );
    }
}
