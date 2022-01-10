// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Inheritance  
 * @author Lodgerio Padlan
 * @dev    Anything related to Owner
 * @notice A simply smart contract to demonstrate inheritance. This is used by Inheritance.sol
            - internal()          
*/

 contract Ownable {

    // address public owner;
    address internal owner;  // can only be accessed by smart contract(Inheritance) that extends Ownable

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller needs to be owner");
        _;   // means continue the execution if require() is true
    }

    constructor() {
        owner = msg.sender;
    }

 }