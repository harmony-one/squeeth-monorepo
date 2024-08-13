// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IController} from "src/interfaces/IController.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IQuoterV2} from "v3-periphery/interfaces/IQuoterV2.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CloseShort is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    IQuoterV2 quoter = IQuoterV2(vm.envAddress("UNI_QUOTER_ADDRESS"));
    address weth = controller.weth();
    address wPowerPerp = controller.wPowerPerp();

    /**
     * @notice close short by swapping WETH for specified wPowerPerp amount
     * @param _vaultId the vault id
     * @param _shortAmount short amount to close (wPowerPerp)
     * @param _collateralWithdrawalAmount collateral withdrawal amount (WETH)
     * @param _slippage slippage tolerance in percentage
     * @return burnedWPowerPerpAmount burned wPowerPerp amount
     */
    function run(
        uint256 _vaultId,
        uint256 _shortAmount,
        uint256 _collateralWithdrawalAmount,
        uint8 _slippage
    ) public returns (uint256 burnedWPowerPerpAmount) {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        IERC20(weth).approve(address(router), type(uint256).max);

        uint24 fee = pool.fee();

        // This could revert due to low liquidity
        (uint256 amountInMaximum, , , ) = quoter.quoteExactOutputSingle(
            IQuoterV2.QuoteExactOutputSingleParams({
                tokenIn: weth,
                tokenOut: wPowerPerp,
                fee: fee,
                amount: _shortAmount,
                sqrtPriceLimitX96: 0
            })
        );

        amountInMaximum =
            amountInMaximum +
            ((amountInMaximum * _slippage) / 100);

        router.exactOutputSingle(
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: weth,
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp + 60,
                amountOut: _shortAmount,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            })
        );

        burnedWPowerPerpAmount = controller.burnPowerPerpAmount(
            _vaultId,
            _shortAmount,
            _collateralWithdrawalAmount
        );

        vm.stopBroadcast();
    }
}
