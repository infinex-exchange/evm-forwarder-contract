// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "./Forwarder.sol";

contract ForwarderFactory {
    address public owner;
    address public instance;

    constructor() {
        owner = msg.sender;
        
        bytes memory deploymentData = abi.encodePacked(type(Forwarder).creationCode);
        address _instance;

        assembly {
            _instance := create2(
                0x0, add(0x20, deploymentData), mload(deploymentData), 0
            )
        }
        
        require(_instance != address(0));
        instance = _instance;
    }
    
    function get(uint256 salt) external returns (Forwarder forwarder) {
        require(msg.sender == owner);
        require(instance != address(0));
        
        bytes20 targetBytes = bytes20(instance);

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