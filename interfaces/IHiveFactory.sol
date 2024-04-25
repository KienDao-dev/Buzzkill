// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IHiveFactory {
    function totalHives() external view returns (uint256);

    function createHive() external returns (uint256);
}
