// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract Liquidate is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    function run(
        uint256 _vaultId,
        uint256 _maxDebtAmount
    ) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        controller.liquidate(_vaultId, _maxDebtAmount);

        vm.stopBroadcast();
    }
}