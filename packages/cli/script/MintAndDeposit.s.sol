// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script, console} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract MintAndDeposit is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    function run(
        uint256 _vaultId, 
        uint256 _collateralAmount, 
        uint256 _powerPerpAmount, 
        uint256 _uniTokenId,
        bool _isWAmount
    ) public {
        uint256 vaultId;
        uint256 amount;

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_isWAmount) {
            (vaultId) = controller.mintWPowerPerpAmount{value: _collateralAmount}(
                _vaultId,
                _powerPerpAmount,
                _uniTokenId
            );
        } else {
            (vaultId, amount) = controller.mintPowerPerpAmount{value: _collateralAmount}(
                _vaultId,
                _powerPerpAmount,
                _uniTokenId
            );           
        }

        vm.stopBroadcast();

        console.log("Vault ID: %d", vaultId);
        console.log("Amount: %d", amount);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}