// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract DepositCollateral is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    /**
     * @notice deposit collateral and/or uniswap v3 position token to a vault
     * @param _vaultId id of the vault
     * @param _collateralAmount amount of eth as collateral
     * @param _uniTokenId id of uniswap v3 position token
     */
    function run(
        uint256 _vaultId,
        uint256 _collateralAmount,
        uint256 _uniTokenId
    ) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_collateralAmount > 0)
            controller.deposit{value: _collateralAmount}(_vaultId);

        if (_uniTokenId > 0)
            controller.depositUniPositionToken(_vaultId, _uniTokenId);

        vm.stopBroadcast();
    }
}