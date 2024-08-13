// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IController} from "src/interfaces/IController.sol";
import {ICrabStrategyV2} from "src/interfaces/ICrabStrategyV2.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CrabDeposit is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    ICrabStrategyV2 strategy =
        ICrabStrategyV2(payable(vm.envAddress("CRAB_STRATEGY_V2_ADDRESS")));
    address wPowerPerp = controller.wPowerPerp();

    /**
     * @notice depsit ETH into strategy, return wSqueeth and strategy token
     * @param _ethAmount amount of ETH to deposit
     * @return crabAmount the amount of strategy token received
     */
    function run(uint256 _ethAmount) public returns (uint256 crabAmount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        // initializing strategy state
        controller.setFeeRecipient(msg.sender);
        controller.setFeeRate(50);
        strategy.initialize(0, 0, 0, 0, 1000e18);

        uint256 balanceBefore = IERC20(address(strategy)).balanceOf(msg.sender);

        strategy.deposit{value: _ethAmount}();

        uint256 balanceAfter = IERC20(address(strategy)).balanceOf(msg.sender);

        vm.stopBroadcast();

        return balanceAfter - balanceBefore;
    }
}
