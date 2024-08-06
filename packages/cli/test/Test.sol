// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {IController} from "src/interfaces/IController.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3MintCallback} from "v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {TickMath} from "v3-core/contracts/libraries/TickMath.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IV3SwapRouter} from "swap-router-contracts/interfaces/IV3SwapRouter.sol";

contract TestTrading is Test {
    IController controller = IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    // IV3SwapRouter router = IV3SwapRouter(vm.envAddress("SWAP_ROUTER_ADDRESS")); // Other SwapRouter02 Router
    ISwapRouter router = ISwapRouter(vm.envAddress("SWAP_ROUTER_ADDRESS"));
    INonfungiblePositionManager positionManager = INonfungiblePositionManager(vm.envAddress("NONFUNGIBLE_POSITION_MANAGER_ADDRESS"));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    IWETH9 weth = IWETH9(controller.weth());
    IERC20 wPowerPerp = IERC20(controller.wPowerPerp());


    function testOpenLong() public {
        address token0 = pool.token0();
        address token1 = pool.token1();
        uint24 fee = pool.fee();
        int24 tickSpacing = pool.tickSpacing();

        console.logUint(fee);
        console.logInt(tickSpacing);
    
        address Alice = makeAddr("Alice");
        address Bob = makeAddr("Bob");

        deal(Alice, 100  ether);
        deal(Bob, 100 ether);

        vm.startPrank(Alice);
        weth.deposit{value: 50 ether}();

        (uint256 vaultId) = controller.mintWPowerPerpAmount{value: 50 ether}(
                0,
                50 ether,
                0
        );

        // console.logUint(vaultId);
        // console.logUint(wPowerPerp.balanceOf(address(this)));
        // console.logUint(IERC20(address(weth)).balanceOf(address(this)));
        // console.logAddress(address(weth));
        // console.logAddress(token0);
        // console.logAddress(token1);
        // console.logAddress(address(this));

        IERC20(address(token0)).approve(address(positionManager), 50 ether);
        IERC20(address(token1)).approve(address(positionManager), 50 ether);

        console.log("Before");
        console.logUint(pool.liquidity());

        positionManager.mint(
            // INonfungiblePositionManager.MintParams({
            //     token0: token0,
            //     token1: token1,
            //     fee: fee,
            //     tickLower: (-887272 / 60) * 60, // this doesnt work, when using constant
            //     tickUpper: (887272 / 60) * 60,
            //     amount0Desired: 50 ether,
            //     amount1Desired: 50 ether,
            //     amount0Min: 0,
            //     amount1Min: 0,
            //     recipient: Alice,
            //     deadline: block.timestamp
            // })
            INonfungiblePositionManager.MintParams({
                token0: token0,
                token1: token1,
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

        vm.warp(block.timestamp + 5);

        (uint160 sqrtPriceX96, int24 tick,,,,,) = pool.slot0();
        // This price is 0, when using the other token as quote token it's 7
        
        // uint256 sqrtPrice = uint256(sqrtPriceX96);
        // uint256 priceX96 = sqrtPrice * sqrtPrice;
        // uint256 price = priceX96 / (1 << 192);
        // console.logUint(price);

        vm.stopPrank();

        console.log("After");
        console.logUint(pool.liquidity());

        { 
            (uint128 liquidityGross, int128 liquidityNet,,,,,,bool init) = pool.ticks(tick); 
            console.logBool(init);
            console.logUint(liquidityGross);
            console.logInt(liquidityNet);
            // Why liquidity is 0 and why this tick is not initialized?
        }

        vm.startPrank(Bob);

        weth.deposit{value: 0.5 ether}();
        weth.approve(address(router), 0.5 ether);

        // Doesnt work
        // router.exactInputSingle(
        //     IV3SwapRouter.ExactInputSingleParams({
        //         tokenIn: address(weth),
        //         tokenOut: token0,
        //         fee: fee,
        //         recipient: Bob,
        //         amountIn: 1e16,
        //         amountOutMinimum: 1,
        //         sqrtPriceLimitX96: type(uint160).max
        //     })
        // );


        router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: token0,
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp,
                amountIn: 1e16, // very small amount, tried with other ones - doesnt work
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        // Doesnt work
        // router.exactInput(
        //     ExactInputParams({
        //         path: abi.encodePacked(address(weth), fee, token0),
        //         recipient: Bob,
        //         amountIn: 1e16,
        //         amountOutMinimum: 0
        //     })
        // );

        vm.stopPrank();
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return this.onERC721Received.selector;
    }
}