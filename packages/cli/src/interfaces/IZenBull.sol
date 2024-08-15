// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;

interface IZenBull {
    function deposit(uint256 _crabAmount) external payable;

    function withdraw(uint256 _bullAmount) external;
}
