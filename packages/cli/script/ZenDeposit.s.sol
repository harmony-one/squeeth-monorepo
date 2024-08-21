// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IZenBull} from "src/interfaces/IZenBull.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ZenDeposit is Script {
    IZenBull zenBull = IZenBull(payable(vm.envAddress("ZENBULL_ADDRESS")));
    address crabStrategy = vm.envAddress("CRAB_STRATEGY_V2_ADDRESS");

    /**
     * @notice deposit to crab: deposits crab and ETH, receives USDC, wPowerPerp and Bull token
     * @param _crabAmount amount of crab to deposit
     */
    function run(uint256 _crabAmount) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        IERC20(crabStrategy).approve(address(zenBull), _crabAmount);

        zenBull.deposit(_crabAmount);

        vm.stopBroadcast();
    }
}
