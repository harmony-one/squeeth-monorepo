// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { DeployScript } from "./DeployScript.s.sol";

contract HarmonyMainnetDeployScript is DeployScript {
    address public ownerAddress = vm.envAddress("OWNER_ADDRESS");
    address public constant zenBullAddress = 0xbD429107EEba27caA8A0a135Fb3037B5a0b1f007;
    address public constant eulerSimpleLensAddress = 0x0F0C5b40C4502dD718726709cB05534F99c6220d;
    address public constant flashZenAddress = 0x135b7d561f1D56935bD55e9c93EABDdCB7b95a08;
    address public constant uniFactoryAddress = 0x12d21f5d0Ab768c312E19653Bf3f89917866B8e8;

    uint256 public constant initialMinEthAmount = 1e18;
    uint256 public constant initialMinZenBullAmount = 1;

    constructor()
        DeployScript(
            ownerAddress,
            zenBullAddress,
            eulerSimpleLensAddress,
            flashZenAddress,
            uniFactoryAddress,
            initialMinEthAmount,
            initialMinZenBullAmount
        )
    { }
}
