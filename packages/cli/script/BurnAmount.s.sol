// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract BurnAmount is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    /**
     * @notice burn wPowerPerp and remove collateral from a vault or 
     * @notice burn powerPerp and remove collateral from a vault
     * @param _vaultId id of the vault
     * @param _burnAmount amount of powerPerp to burn
     * @param _withdrawAmount amount of collateral to withdraw
     * @param _isWAmount if the input amount is a wPowerPerp amount (as opposed to rebasing powerPerp)
     * @return amount the amount of powerPerp burned, 0 if _isWAmount is true
    */
    function run(
        uint256 _vaultId,
        uint256 _burnAmount,
        uint256 _withdrawAmount,
        bool _isWAmount
    ) public returns (uint256 amount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_isWAmount) {
            controller.burnWPowerPerpAmount(
                _vaultId,
                _burnAmount,
                _withdrawAmount
            );
        } else {
            amount = controller.burnPowerPerpAmount(
                _vaultId,
                _burnAmount,
                _withdrawAmount
            );           
        }

        vm.stopBroadcast();
    }
}