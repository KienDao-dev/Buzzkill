// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Hive.sol";

contract HiveFactory {
    event HiveCreated(uint256 hiveId, address hiveAddress);

    uint256 public totalHives;

    function createHive() external returns (uint256) {
        Hive newHive = new Hive();
        totalHives++;
        emit HiveCreated(totalHives, address(newHive));
        return totalHives;
    }
}
