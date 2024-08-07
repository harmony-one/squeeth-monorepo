// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract Liquidate is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));

    /**
     * @notice if a vault is under the 150% collateral ratio, anyone can liquidate the vault by burning wPowerPerp
     * @dev liquidator can get back (wPowerPerp burned) * (index price) * (normalizationFactor)  * 110% in collateral
     * @dev normally can only liquidate 50% of a vault's debt
     * @dev if a vault is under dust limit after a liquidation can fully liquidate
     * @dev will attempt to reduceDebt first, and can earn a bounty if sucessful
     * @param _vaultId vault to liquidate
     * @param _maxDebtAmount max amount of wPowerPerpetual to repay
     * @return amount of wPowerPerp repaid
     */
    function run(
        uint256 _vaultId,
        uint256 _maxDebtAmount
    ) public returns (uint256 amount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        amount = controller.liquidate(_vaultId, _maxDebtAmount);

        vm.stopBroadcast();
    }
}