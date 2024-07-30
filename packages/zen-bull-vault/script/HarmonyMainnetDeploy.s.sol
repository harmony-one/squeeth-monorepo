// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import { DeployScript } from "./Deploy.s.sol";

contract HarmonyMainnetDeploy is DeployScript {
    address public systemOwnerAddress = vm.envAddress("OWNER_ADDRESS");
    address public auctionManagerAddress = vm.envAddress("OWNER_ADDRESS");
    address public constant crabAddress = 0x4116c1e672E94742463d26B2E82e6E3b2Eb329A3; // CrabStrategyV2 
    address public constant powerTokenControllerAddress = 0x2Eab3378Fe281b3CE16e0f6F4dEb7d47c644A978; // Controller
    address public constant eulerAddress = 0xCF1C0C140101181d7b0601131b2154Dc88f4B117;
    address public constant eulerMarketsModuleAddress = 0xd240bC98E0B5a84101463d66e899665830118f5a;
    address public constant uniFactoryAddress = 0x12d21f5d0Ab768c312E19653Bf3f89917866B8e8;
    address public constant eTokenAddress = 0x37EdBd95fCFD212299B4E1Ef40d526292B15951d; // eWETH
    address public constant dTokenAddress = 0x3acCFB93aE0604De1E188dAEd09A8acCc1ef0453; // dUSDC
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
