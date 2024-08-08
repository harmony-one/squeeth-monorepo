// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MintAndShort is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    address weth = controller.weth();
    IERC20 wPowerPerp = IERC20(controller.wPowerPerp());

    /**
     * @notice mint specified powerPerp (rebasing) amount and short it
     * @param _vaultId id of the vault, 0 for new vault
     * @param _collateralAmount amount of eth as collateral, not required
     * @param _mintAmount amount to mint and short
     * @param _uniTokenId id of uniswap v3 position token (additional collateral), not required, pass 0 if not using
     * @param _slippage slippage percentage when swapping (shorting)
     * @return vaultId the vaultId that was acted on
     * @return mintedAmount the minted amount
     * @return wethAmount the amount of weth received after shorting
     */
    function run(
        uint256 _vaultId,
        uint256 _collateralAmount,
        uint256 _mintAmount,
        uint256 _uniTokenId,
        uint8 _slippage
    )
        public
        returns (
            uint256 vaultId,
            uint256 mintedAmount,
            uint256 wethAmount
        )
    {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        (vaultId, mintedAmount) = controller.mintPowerPerpAmount{
            value: _collateralAmount
        }(_vaultId, _mintAmount, _uniTokenId);

        uint24 fee = pool.fee();
        uint256 amountOutMinimum = mintedAmount -
            ((mintedAmount * _slippage) / 100);

        wPowerPerp.approve(address(router), mintedAmount);

        wethAmount = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: weth,
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp + 60,
                amountIn: mintedAmount,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
