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

    /**
     * @notice Execute 3 trades, 2 long and 1 short. The first long to close a position, being profitable and the short to as well.
     * @param _wethAmount Amount of WETH to provide as liquidity.
     * @param _bobWethAmount Bob's Amount of WETH to swap for wPowerPerp.
     * @param _charlieMintAmount Charlie's Amount of wPowerPerp to mint and swap for WETH.
     * @param _danWethAmount Dan's Amount of WETH to swap for wPowerPerp.
     *
     */

    function run(
        uint256 _wethAmount,
        uint256 _bobWethAmount,
        uint256 _charlieMintAmount,
        uint256 _danWethAmount
    ) external {
        // Ensure the provided amounts are sufficient for the account balances
        require(
            _wethAmount <= address(msg.sender).balance,
            "Insufficient balance for msg.sender"
        );
        require(_bobWethAmount <= Bob.balance, "Insufficient balance for Bob");
        require(
            _charlieMintAmount <= Charlie.balance,
            "Insufficient balance for Charlie"
        );
        require(_danWethAmount <= Dan.balance, "Insufficient balance for Dan");

        uint24 fee = pool.fee();

        // msg.sender provides liquidity
        {
            int24 tickSpacing = pool.tickSpacing();

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            weth.deposit{value: _wethAmount}();

            controller.mintWPowerPerpAmount{value: _wethAmount}(
                0,
                _wethAmount,
                0
            );

            IERC20(address(weth)).approve(
                address(positionManager),
                _wethAmount
            );
            IERC20(address(wPowerPerp)).approve(
                address(positionManager),
                _wethAmount
            );

            positionManager.mint(
                INonfungiblePositionManager.MintParams({
                    token0: address(wPowerPerp),
                    token1: address(weth),
                    fee: fee,
                    tickLower: (-887272 / tickSpacing) * tickSpacing,
                    tickUpper: (887272 / tickSpacing) * tickSpacing,
                    amount0Desired: _wethAmount,
                    amount1Desired: _wethAmount,
                    amount0Min: 0,
                    amount1Min: 0,
                    recipient: msg.sender,
                    deadline: block.timestamp + 1000
                })
            );

            vm.stopBroadcast();
        }

        // Bob opens long position
        vm.startBroadcast(BobPK);

        weth.deposit{value: _bobWethAmount}();
        weth.approve(address(router), _bobWethAmount);

        uint256 wPowerPerpBob = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Bob,
                deadline: block.timestamp + 1000,
                amountIn: _bobWethAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        vm.stopBroadcast();

        // Charlie opens short position
        vm.startBroadcast(CharliePK);

        (vaultId, mintedAmount) = controller.mintPowerPerpAmount{
            value: _charlieMintAmount
        }(0, _charlieMintAmount, 0);

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

        weth.deposit{value: _danWethAmount}();
        weth.approve(address(router), _danWethAmount);

        uint256 wPowerPerpDan = router.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: address(weth),
                tokenOut: address(wPowerPerp),
                fee: fee,
                recipient: Dan,
                deadline: block.timestamp + 1000,
                amountIn: _danWethAmount,
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

        //Check profits and losses
        console.log("Bob's weth amount: ", wethAmountBob);
        require(wethAmountBob > _bobWethAmount, "Bob is not profitable");

        console.log("Dan's weth amount: ", wethAmountDan);
        require(wethAmountDan < _danWethAmount, "Dan is profitable");

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
