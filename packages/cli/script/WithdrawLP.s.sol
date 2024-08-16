// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract WithdrawLP is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    INonfungiblePositionManager positionManager =
        INonfungiblePositionManager(
            vm.envAddress("UNI_NONFUNGIBLE_POSITION_MANAGER_ADDRESS")
        );

    /**
     * @notice withdraw liquidity from uniswap v3 position and burn wPowerPerp
     * @param _tokenId id of uniswap v3 position token
     * @param _vaultId id of the vault
     * @param _withdrawAmount amount of liquidity to withdraw
     * @return wPowerPerpAmount amount of wPowerPerp burned
     * @return wethAmount amount of weth received
     */
    function run(
        uint256 _tokenId,
        uint256 _vaultId,
        uint256 _withdrawAmount
    ) public returns (uint256 wPowerPerpAmount, uint256 wethAmount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        (, , , , , , , uint128 liquidity, , , , ) = positionManager.positions(
            _tokenId
        );

        (wPowerPerpAmount, wethAmount) = positionManager.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: _tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp + 60
            })
        );

        controller.burnWPowerPerpAmount(
            _vaultId,
            wPowerPerpAmount,
            _withdrawAmount
        );

        vm.stopBroadcast();
    }
}
