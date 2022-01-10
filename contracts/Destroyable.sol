import "./Ownable.sol";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Inheritance  
 * @author Lodgerio Padlan
 * @dev    reduce code duplication           
 * @notice A simply smart contract to demonstrate inheritance
*/

 contract Destroyable is Ownable {

     function destroy() public onlyOwner {
        address payable receiver = msg.sender;
        selfdestruct(receiver);
     }
 }
