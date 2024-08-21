// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;

pragma abicoder v2;

interface ICrabStrategyV2 {
    function deposit() external payable;

    function withdraw(uint256 _craAmbount) external;

    function strategyCap() external view returns (uint256);

    function setStrategyCap(uint256 _capAmount) external;

    function initialize(
        uint256 _wSqueethToMint,
        uint256 _crabSharesToMint,
        uint256 _timeAtLastHedge,
        uint256 _priceAtLastHedge,
        uint256 _strategyCap
    ) external payable;
}
