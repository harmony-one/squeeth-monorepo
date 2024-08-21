// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IZenBull} from "src/interfaces/IZenBull.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ZenWithdraw is Script {
    IZenBull zenBull = IZenBull(payable(vm.envAddress("ZENBULL_ADDRESS")));

    /**
     * @notice withdraw from crab: repay wPowerPerp, USDC and Bull token and receive ETH
     * @param _bullAmount amount of zen bull token to redeem
     */
    function run(uint256 _bullAmount) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        IERC20(address(zenBull)).approve(address(zenBull), _bullAmount);

        zenBull.withdraw(_bullAmount);

        vm.stopBroadcast();
    }
}
