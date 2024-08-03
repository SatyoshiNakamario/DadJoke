// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
        require(success, "Delegatecall failed");
    }

    function upgradeTo(address newImplementation) external {
        // Only allow the owner to upgrade (implement ownership management)
        implementation = newImplementation;
    }
}
