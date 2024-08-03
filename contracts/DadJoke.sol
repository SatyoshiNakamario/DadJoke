// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./EIP20Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract DadJoke is EIP20Interface, Ownable {
    string public name;
    string public symbol;
    uint8 public decimals;
    
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    //ICO Variables
    uint256 private _totalSupply; // Use a private variable for total supply

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply;
        balances[msg.sender] = initialSupply;  // Allocate initial supply to contract deployer
        name = "DadJoke";
        symbol = "DADS";
        decimals = 9;
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

    function withdrawFunds() public onlyOwner {
        payable(owner()).transfer(address(this).balance); // Withdraw accumulated funds
    }

    function mintTokens(uint256 amount) public onlyOwner {
        _totalSupply += amount; // Increase total supply
        balances[owner()] += amount; // Allocate new tokens to the owner
        emit Transfer(address(0), owner(), amount); // Emit transfer event from zero address
    }

}
