// SDPX-License-Identifier: UNLICENSED
pragma solidity =0.7.6;
pragma abicoder v2;

import {Script} from "forge-std/Script.sol";
import {IWETH9} from "src/interfaces/IWETH9.sol";
import {IController} from "src/interfaces/IController.sol";
import {ISwapRouter} from "v3-periphery/interfaces/ISwapRouter.sol";
import {IUniswapV3Pool} from "v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import {INonfungiblePositionManager} from "v3-periphery/interfaces/INonfungiblePositionManager.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MintAndLP is Script {
    IController controller =
        IController(payable(vm.envAddress("CONTROLLER_ADDRESS")));
    IUniswapV3Pool pool = IUniswapV3Pool(controller.wPowerPerpPool());
    ISwapRouter router = ISwapRouter(vm.envAddress("UNI_SWAP_ROUTER_ADDRESS"));
    INonfungiblePositionManager positionManager =
        INonfungiblePositionManager(
            vm.envAddress("UNI_NONFUNGIBLE_POSITION_MANAGER_ADDRESS")
        );
    IWETH9 weth = IWETH9(controller.weth());
    IERC20 wPowerPerp = IERC20(controller.wPowerPerp());

    /**
     * @notice mint specified powerPerp (rebasing) amount and short it
     * @param _vaultId id of the vault, 0 for new vault
     * @param _collateralAmount amount of eth as collateral, not required
     * @param _mintAmount amount of wPowerPerp to mint and provide as liquidity
     * @param _uniTokenId id of uniswap v3 position token (additional collateral), not required, pass 0 if not using
     * @param _wethAmount amount of weth to provide as liquidity
     * @return vaultId the vaultId that was acted on
     * @return wPowerPerpAmount the provided wPowerPerp amount
     * @return wethAmount the provided weth amount
     * @return tokenId the id of the uniswap v3 position token
     * @return liquidity the amount of liquidity for this position
     */
    function run(
        uint256 _vaultId,
        uint256 _collateralAmount,
        uint256 _mintAmount,
        uint256 _uniTokenId,
        uint256 _wethAmount
    )
        public
        returns (
            uint256 vaultId,
            uint256 wPowerPerpAmount,
            uint256 wethAmount,
            uint256 tokenId,
            uint128 liquidity
        )
    {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        (vaultId) = controller.mintWPowerPerpAmount{value: _collateralAmount}(
            _vaultId,
            _mintAmount,
            _uniTokenId
        );

        uint24 fee = pool.fee();
        address token0 = pool.token0();
        address token1 = pool.token1();
        int24 tickSpacing = pool.tickSpacing();

        weth.deposit{value: _wethAmount}();
        weth.approve(address(positionManager), _wethAmount);
        wPowerPerp.approve(address(positionManager), _mintAmount);

        (tokenId, liquidity, wPowerPerpAmount, wethAmount) = positionManager
            .mint(
                INonfungiblePositionManager.MintParams({
                    token0: token0,
                    token1: token1,
                    fee: fee,
                    tickLower: (-887272 / tickSpacing) * tickSpacing,
                    tickUpper: (887272 / tickSpacing) * tickSpacing,
                    amount0Desired: _mintAmount,
                    amount1Desired: _wethAmount,
                    amount0Min: 0,
                    amount1Min: 0,
                    recipient: msg.sender,
                    deadline: block.timestamp + 60
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
