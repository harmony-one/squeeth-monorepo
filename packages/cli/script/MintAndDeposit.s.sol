// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;

import {Script, console} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";


contract MintAndDeposit is Script {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));


    /**
     * @notice deposit collateral and mint wPowerPerp (non-rebasing) for specified powerPerp (rebasing) amount
     * @notice or mint wPowerPerp (non-rebasing) for specified wPowerPerp amount
     * @param _vaultId id of the vault, 0 for new vault
     * @param _collateralAmount amount of eth as collateral
     * @param _mintAmount amount to mint
     * @param _uniTokenId id of uniswap v3 position token
     * @param _isWAmount if the input amount is a wPowerPerp amount (as opposed to rebasing powerPerp)
     * @return vaultId the vaultId that was acted on or for a new vault the newly created vaultId
     * @return amount the minted wPowerPerp amount, 0 if _isWAmount is true
     */
    function run(
        uint256 _vaultId, 
        uint256 _collateralAmount, 
        uint256 _mintAmount, 
        uint256 _uniTokenId,
        bool _isWAmount
    ) public returns (uint256 vaultId, uint256 amount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        if (_isWAmount) {
            (vaultId) = controller.mintWPowerPerpAmount{value: _collateralAmount}(
                _vaultId,
                _mintAmount,
                _uniTokenId
            );
        } else {
            (vaultId, amount) = controller.mintPowerPerpAmount{value: _collateralAmount}(
                _vaultId,
                _mintAmount,
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