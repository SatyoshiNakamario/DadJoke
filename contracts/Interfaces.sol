// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDadJokeToken {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    // Add other ERC20 functions as needed
}

interface IICO {
    function buyTokens() external payable;
    function endICO() external;
    function withdrawFunds() external;
    // Define any other functions related to the ICO management
}
