// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";

contract WithdrawCollateral is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    /**
     * @notice withdraw collateral from a vault
     * @param _vaultId id of the vault
     * @param _collateralAmount amount of eth to withdraw
     * @param _isUniToken if the collateral is a uniswap v3 position token
     */
    function run(
        uint256 _vaultId,
        uint256 _collateralAmount,
        bool _isUniToken
    ) public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_collateralAmount > 0)
            controller.withdraw(_vaultId, _collateralAmount);

        if (_isUniToken) controller.withdrawUniPositionToken(_vaultId);

        vm.stopBroadcast();
    }
}
