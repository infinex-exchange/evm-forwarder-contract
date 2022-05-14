// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "./Forwarder.sol";

contract ForwarderFactory {
    address public owner;
    Forwarder public original;

    constructor() {
        owner = msg.sender;
        
        original = new Forwarder();
        require(address(original) != address(0));
    }
    
    function createClone(uint256 salt) external returns (Forwarder forwarder) {
        require(msg.sender == owner);
        
        bytes20 targetBytes = bytes20(address(original));

        assembly {
            let clone := mload(0x40)
            mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(clone, 0x14), targetBytes)
            mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
            forwarder := create2(0, clone, 0x37, salt)
        }
        
        require(address(forwarder) != address(0));
    }
}