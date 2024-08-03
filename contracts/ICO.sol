// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DadJoke.sol";
import "./ICO_Phases.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ICO is Ownable, ICO_Phases {

    DadJoke public dadJokeToken; // Referencing the DadJoke contract
    uint256 public tokenPrice; // Price per token in wei
    uint256 public totalTokensSold; // Total tokens sold during the ICO
    uint256 public icoStartTime; // When it all starts
    uint256 public icoEndTime; // When it all ends
    bool public icoActive; // If it's still going on or not

    constructor(DadJoke _dadJokeToken, uint256 duration, uint256 price) {
        dadJokeToken = _dadJokeToken; // Set the DadJoke token
        tokenPrice = price; // Set the token price
        icoStartTime = block.timestamp; // Set the ICO start time
        icoEndTime = block.timestamp + duration; // Set ICO end time
        icoActive = true; // Set it off!

        // Initialize
        startSeedPhase(); // Start with the Seed Phase
    }

    modifier onlyDuringICO() {
        require(icoActive, "ICO isn't active");
        require(block.timestamp >= icoStartTime && block.timestamp <= icoEndTime, "ICO isn't going on. Don't worry 'bout it.");
        _;
    }

    function buyTokens() public payable onlyDuringICO {
        require(msg.value > 0, "Send ETH to buy DADS");
        uint256 tokensToBuy = (msg.value / tokenPrice) * 10**dadJokeToken.decimals(); // Calculate tokens to buy

        require(tokensToBuy <= dadJokeToken.balanceOf(address(this)), "Not enough DADS in the ICO contract");

        dadJokeToken.transfer(msg.sender, tokensToBuy);
        totalTokensSold += tokensToBuy;
    }

    function endICO() public onlyOwner {
        require(block.timestamp > icoEndTime, "ICO is still going on.");
        icoActive = false; // End it all!
    }

    function setTokenPrice(uint256 newPrice) public onlyOwner {
        tokenPrice = newPrice; // A
