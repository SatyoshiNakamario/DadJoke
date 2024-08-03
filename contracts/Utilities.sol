// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library Utilities {
    // Safely add two numbers and check for overflow
    function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
        require(a + b >= a, "SafeMath: addition overflow");
        return a + b;
    }

    // Safely subtract two numbers and check for underflow
    function safeSubtract(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction underflow");
        return a - b;
    }

    // Other common functions can be added here
}
