// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { DeployScript } from "./DeployScript.s.sol";

contract HarmonyTestnetDeployScript is DeployScript {
    address public constant ownerAddress = 0xD78731472512ddAb457bD64d027e1BBc2Ce4aBC0;
    address public constant zenBullAddress = 0x9bAD58c14B0b00bb7A48d3F089Fd58778294ad32;
    address public constant eulerSimpleLensAddress = 0xDEA7821940D9aE0ee7Edb7Ede8c1F1eaf13068A2;
    address public constant flashZenAddress = 0xC31690d3220900Db714d8C6339715273F5B63a77;
    address public constant uniFactoryAddress = 0x14d34078f68d07859CF57B25785B923c443DaE71;

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
