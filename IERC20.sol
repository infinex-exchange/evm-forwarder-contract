// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

interface IERC20 {
    function transfer(address to, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}