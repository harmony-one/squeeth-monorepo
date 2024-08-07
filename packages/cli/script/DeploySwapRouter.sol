// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {SwapRouter} from "v3-periphery/SwapRouter.sol";


contract Liquidate is Script {
    function run(
    ) public returns (address) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address uniFactory = 0x12d21f5d0Ab768c312E19653Bf3f89917866B8e8;
        address weth = 0xcF664087a5bB0237a0BAd6742852ec6c8d69A27a;

        SwapRouter swapRouter = new SwapRouter(uniFactory, weth);

        vm.stopBroadcast();

        return address(swapRouter);
    }
}