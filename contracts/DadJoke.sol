// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EIP20Interface.sol";

contract DadJoke is EIP20Interface {
    string public name;
    string public symbol;
    uint8 public decimals;
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    //ICO Variables
    uint256 public tokenPrice; //Price per token in weiiiiiis 
    uint256 public totalTokensSold; // Total tokens sold during the ICO
    uint256 public icoStartTime; //When it all starts
    uint256 public icoEndTime; //When it all ends
    bool public icoActive; //If it's still going down er nah
     

    constructor(uint256 initialSupply) {
        totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;  // Allocate initial supply to contract deployer
        name = "DadJoke";
        symbol = "DADS";
        decimals = 9;

        tokenPrice = price; //set the token price
        icoStartTime = block.timestamp; //set the ICO start time
        icoEndTime = block.timestamp + duration; //set ICO end of days
        icoActive = true; //Set it off!
    }

    modifier onlyDuringICO(){
        require(icoActive, "ICO isn't active");
        require(block.timestamp >= icoStartTime && block.timestamp <= icoEndTime, "ICO isn't going on. Don't worry 'bout it.");
        _;
    }

    function buyTokens() public payable onlyDuringICO{
        require(msg.value > 0, "Send ETH to buy DADS");
        uint256 tokensToBuy = (msg.value / tokenPrice) * 10**decimals; //Calculate tokens to buy

        require(tokensToBuy <= balances[msg.sender], "There aren't enough DADS available.");
        require(tokensToBuy <= balances[address(this)], "Not enough DADS in the ICO contract");

        balances[msg.sender] += tokensToBuy;
        balances[address(this)] -= tokensToBuy;
        totalTokensSold += tokensToBuy;

        emit Transfer(address(this), msg.sender, tokensToBuy);
    }

    function endICO public{
        require(block.timestamp) > icoEndTime, "ICO is still going on."
        icoActive = false; //End it all!
    }

    function balanceOf(address _owner) public view override returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[msg.sender], "Insufficient balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(_value <= balances[_from], "Insufficient balance");
        require(_value <= allowed[_from][msg.sender], "Allowance exceeded");

        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
}
