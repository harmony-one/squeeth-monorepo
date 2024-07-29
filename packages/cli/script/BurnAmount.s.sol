// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract BurnAmount is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    function run(
        uint256 _vaultId,
        uint256 _powerPerpAmount,
        uint256 _withdrawAmount,
        bool _isWAmount
    ) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_isWAmount) {
            controller.burnWPowerPerpAmount(
                _vaultId,
                _powerPerpAmount,
                _withdrawAmount
            );
        } else {
            controller.burnPowerPerpAmount(
                _vaultId,
                _powerPerpAmount,
                _withdrawAmount
            );           
        }

        vm.stopBroadcast();
    }
}