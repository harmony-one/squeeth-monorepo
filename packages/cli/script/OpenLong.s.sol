// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IController} from "src/interfaces/IController.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OpenLong is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    IWETH9 weth = IWETH9(controller.weth());
    address wPowerPerp = controller.wPowerPerp();

    /**
     * @notice long by swapping WETH for specified wPowerPerp amount
     * @param _wethAmount amount of WETH to swap
     * @param _slippage slippage percentage when swapping (longing)
     * @return wPowerPerpAmount the amount of wPowerPerp longed
     */
    function run(uint256 _wethAmount, uint8 _slippage)
        public
        returns (uint256 wPowerPerpAmount)
    {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        weth.deposit{value: _wethAmount}();
        weth.approve(address(router), _wethAmount);

        uint24 fee = pool.fee();
        uint256 amountOutMinimum = _wethAmount -
            ((_wethAmount * _slippage) / 100);

        wPowerPerpAmount = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: wPowerPerp,
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp + 60,
                amountIn: _wethAmount,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();
    }
}
