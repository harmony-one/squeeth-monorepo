// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {ICrabStrategyV2} from "src/interfaces/ICrabStrategyV2.sol";

contract CrabWithdraw is Script {
    ICrabStrategyV2 strategy =
        ICrabStrategyV2(payable(vm.envAddress("CRAB_STRATEGY_V2_ADDRESS")));

    /**
     * @notice withdraw ETH from strategy, return wSqueeth and strategy token
     * @param _crabAmount amount of strategy token to withdraw
     * @return ethAmount the amount of ETH received
     */
    function run(uint256 _crabAmount) public returns (uint256 ethAmount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        uint256 balanceBefore = address(this).balance;

        strategy.withdraw(_crabAmount);

        uint256 balanceAfter = address(this).balance;

        vm.stopBroadcast();

        return balanceAfter - balanceBefore;
    }
}
