// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IController} from "src/interfaces/IController.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract CloseLong is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    address weth = controller.weth();
    address wPowerPerp = controller.wPowerPerp();

    /**
     * @notice close long by swapping wPowerPerp for specified WETH amount
     * @param _wPowerPerpAmount amount of wPowerPerp to swap
     * @param _slippage slippage percentage when swapping (closing)
     * @return wethAmount the amount of WETH received
     */
    function run(uint256 _wPowerPerpAmount, uint8 _slippage)
        public
        returns (uint256 wethAmount)
    {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        IERC20(wPowerPerp).approve(address(router), _wPowerPerpAmount);

        uint24 fee = pool.fee();
        uint256 amountOutMinimum = _wPowerPerpAmount -
            ((_wPowerPerpAmount * _slippage) / 100);

        wethAmount = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: wPowerPerp,
                tokenOut: weth,
                fee: fee,
                recipient: msg.sender,
                deadline: block.timestamp + 60,
                amountIn: _wPowerPerpAmount,
                amountOutMinimum: amountOutMinimum,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();
    }
}
