// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {IController} from "src/interfaces/IController.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {SwapRouter} from "v3-periphery/SwapRouter.sol";
import {IUniswapV3MintCallback} from "v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {TickMath} from "v3-core/contracts/libraries/TickMath.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IV3SwapRouter} from "swap-router-contracts/interfaces/IV3SwapRouter.sol";
import {GetCode} from "src/libraries/GetCode.sol";

contract TestProfitableTrades is Test {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    INonfungiblePositionManager positionManager =
        INonfungiblePositionManager(
            vm.envAddress("UNI_NONFUNGIBLE_POSITION_MANAGER_ADDRESS")
        );
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    IWETH9 weth = IWETH9(controller.weth());
    IERC20 wPowerPerp = IERC20(controller.wPowerPerp());
    uint256 vaultId; // stack too deep
    uint256 mintedAmount; // stack too deep

    function testOpenLong() public {
        uint24 fee = pool.fee();

        address Alice = makeAddr("Alice");
        address Bob = makeAddr("Bob");
        address Charlie = makeAddr("Charlie");
        address Dan = makeAddr("Dan");

        deal(Alice, 100 ether);
        deal(Bob, 100 ether);
        deal(Charlie, 100 ether);
        deal(Dan, 100 ether);

        // Alice provides liquidity
        {
            int24 tickSpacing = pool.tickSpacing();

            vm.startPrank(Alice);
            weth.deposit{value: 50 ether}();

            controller.mintWPowerPerpAmount{value: 50 ether}(0, 50 ether, 0);

            IERC20(address(weth)).approve(address(positionManager), 50 ether);
            IERC20(address(wPowerPerp)).approve(
                address(positionManager),
                50 ether
            );

            positionManager.mint(
                INonfungiblePositionManager.MintParams({
                    token0: address(wPowerPerp),
                    token1: address(weth),
                    fee: fee,
                    tickLower: (-887272 / tickSpacing) * tickSpacing,
                    tickUpper: (887272 / tickSpacing) * tickSpacing,
                    amount0Desired: 50 ether,
                    amount1Desired: 50 ether,
                    amount0Min: 0,
                    amount1Min: 0,
                    recipient: Alice,
                    deadline: block.timestamp
                })
            );

            vm.stopPrank();
        }

        vm.startPrank(Bob);

        weth.deposit{value: 20 ether}();
        weth.approve(address(router), 20 ether);

        uint256 wPowerPerpBob = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp,
                amountIn: 20 ether,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopPrank();

        vm.startPrank(Charlie);

        (vaultId, mintedAmount) = controller.mintPowerPerpAmount{
            value: 10 ether
        }(0, 10 ether, 0);

        wPowerPerp.approve(address(router), mintedAmount);

        uint256 wethAmountCharlie = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: address(weth),
                fee: fee,
                recipient: Charlie,
                deadline: block.timestamp,
                amountIn: mintedAmount,
                amountOutMinimum: 1e18,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopPrank();

        vm.startPrank(Dan);

        weth.deposit{value: 40 ether}();

        weth.approve(address(router), 40 ether);

        uint256 wPowerPerpDan = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Dan,
                deadline: block.timestamp,
                amountIn: 40 ether,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopPrank();

        vm.startPrank(Bob);

        wPowerPerp.approve(address(router), wPowerPerpBob);

        uint256 wethAmountBob = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: address(weth),
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp,
                amountIn: wPowerPerpBob,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopPrank();

        vm.startPrank(Dan);

        wPowerPerp.approve(address(router), wPowerPerpDan);

        uint256 wethAmountDan = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: address(weth),
                fee: fee,
                recipient: Dan,
                deadline: block.timestamp,
                amountIn: wPowerPerpDan,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopPrank();

        vm.startPrank(Charlie);

        weth.approve(address(router), wethAmountCharlie);

        uint256 wPowerPerpCharlie = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Charlie,
                deadline: block.timestamp,
                amountIn: wethAmountCharlie,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        controller.burnWPowerPerpAmount(vaultId, mintedAmount, 0);

        vm.stopPrank();

        // Bob is profitable after closing long
        console.log("Bob's weth amount: ", wethAmountBob);
        assert(wethAmountBob > 20 ether);

        // Dan is not profitable after closing long
        console.log("Dan's weth amount: ", wethAmountDan);
        assert(wethAmountDan < 40 ether);

        // Charlie is profitable after closing short
        console.log(
            "Charlie's wPowerPerp amount before burn: ",
            wPowerPerpCharlie
        );
        console.log(
            "Charlie's wPowerPerp balance after close short: ",
            wPowerPerp.balanceOf(Charlie)
        );
        assert(wPowerPerpCharlie > mintedAmount);
        assert(wPowerPerp.balanceOf(Charlie) > 0);
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
