// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

import "./IERC20.sol";

contract Forwarder {
    address constant public target = 0x0000000000000000000000000000000000000000;
    
    // Flush ETH sent before deployment
    function flush() external {
        payable(target).transfer(address(this).balance);
    }
    
    // Auto forward ETH sent after deployment
    receive() external payable {
        payable(target).transfer(msg.value);
    }
    
    // Flush token sent before and after deployment
    function flushToken(address tokenContractAddress) external {
        IERC20 tokenContract = IERC20(tokenContractAddress);
        uint256 forwarderBalance = tokenContract.balanceOf(address(this));
        if(forwarderBalance == 0) {
            revert();
        }
        tokenContract.transfer(target, forwarderBalance);
    }
    
    // Any value ETH transfer
    function transferTo(address payable to, uint256 amount) external {
        require(msg.sender == target);
        
        if(address(this).balance < amount) {
            revert();
        }
        to.transfer(amount);
    }
    
    // Any value token transfer
    function transferTokenTo(address tokenContractAddress, address to, uint256 amount) external {
        require(msg.sender == target);
        
        IERC20 tokenContract = IERC20(tokenContractAddress);
        uint256 forwarderBalance = tokenContract.balanceOf(address(this));
        if(forwarderBalance < amount) {
            revert();
        }
        tokenContract.transfer(to, amount);
    }
}