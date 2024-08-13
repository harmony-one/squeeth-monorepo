// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IController} from "src/interfaces/IController.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ProfitableTrades is Script {
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

    uint256 AlicePK = vm.envUint("ALICE_PK");
    uint256 BobPK = vm.envUint("BOB_PK");
    uint256 CharliePK = vm.envUint("CHARLIE_PK");
    uint256 DanPK = vm.envUint("DAN_PK");
    address Alice = vm.envAddress("ALICE_ADDRESS");
    address Bob = vm.envAddress("BOB_ADDRESS");
    address Charlie = vm.envAddress("CHARLIE_ADDRESS");
    address Dan = vm.envAddress("DAN_ADDRESS");

    uint256 vaultId; // stack too deep
    uint256 mintedAmount; // stack too deep

    function run() external {
        uint24 fee = pool.fee();

        // Alice provides liquidity
        {
            int24 tickSpacing = pool.tickSpacing();

            vm.startBroadcast(AlicePK);
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
                    deadline: block.timestamp + 1000
                })
            );

            vm.stopBroadcast();
        }

        // Bob opens long position
        vm.startBroadcast(BobPK);

        weth.deposit{value: 20 ether}();
        weth.approve(address(router), 20 ether);

        uint256 wPowerPerpBob = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp + 1000,
                amountIn: 20 ether,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Charlie opens short position
        vm.startBroadcast(CharliePK);

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
                deadline: block.timestamp + 1000,
                amountIn: mintedAmount,
                amountOutMinimum: 1e18,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Dan opens long position
        vm.startBroadcast(DanPK);

        weth.deposit{value: 40 ether}();
        weth.approve(address(router), 40 ether);

        uint256 wPowerPerpDan = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Dan,
                deadline: block.timestamp + 1000,
                amountIn: 40 ether,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Bob closes long position
        vm.startBroadcast(BobPK);

        wPowerPerp.approve(address(router), wPowerPerpBob);

        uint256 wethAmountBob = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: address(weth),
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp + 1000,
                amountIn: wPowerPerpBob,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Dan closes long position
        vm.startBroadcast(DanPK);

        wPowerPerp.approve(address(router), wPowerPerpDan);

        uint256 wethAmountDan = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(wPowerPerp),
                tokenOut: address(weth),
                fee: fee,
                recipient: Dan,
                deadline: block.timestamp + 1000,
                amountIn: wPowerPerpDan,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Charlie closes short position
        vm.startBroadcast(CharliePK);

        weth.approve(address(router), wethAmountCharlie);

        uint256 wPowerPerpCharlie = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Charlie,
                deadline: block.timestamp + 1000,
                amountIn: wethAmountCharlie,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        controller.burnWPowerPerpAmount(vaultId, mintedAmount, 0);

        vm.stopBroadcast();

        // Check profits and losses
        console.log("Bob's weth amount: ", wethAmountBob);
        require(wethAmountBob > 20 ether, "Bob is not profitable");

        console.log("Dan's weth amount: ", wethAmountDan);
        require(wethAmountDan < 40 ether, "Dan is profitable");

        console.log(
            "Charlie's wPowerPerp amount before burn: ",
            wPowerPerpCharlie
        );
        console.log(
            "Charlie's wPowerPerp balance after close short: ",
            wPowerPerp.balanceOf(Charlie)
        );
        require(wPowerPerpCharlie > mintedAmount, "Charlie is not profitable");
        require(wPowerPerp.balanceOf(Charlie) > 0, "Charlie has no balance");
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
