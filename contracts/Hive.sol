// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract Hive {
    uint256 public honeyPot;

    function depositHoney(uint256 amount) external {
        honeyPot += amount;
    }

    function withdrawHoney(uint256 amount) external {
        require(amount <= honeyPot, "Insufficient honey balance");
        honeyPot -= amount;
    }
}