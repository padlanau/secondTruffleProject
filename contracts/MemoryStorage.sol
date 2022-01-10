// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Memory And Storage
 * @author Lodgerio Padlan
 * @dev address that deployed the contract         
 * @notice A simply smart contract to demonstrate Memory And Storage differences. In order to save
           the balance in the storage 
      
*/

 contract MemoryStorage {

    mapping(uint => User) users;
      //  			^     ^
	  //			|_____|	
  
      // read: input an index and you will get a user, which is in User object  
      // to save                  :  users[uint] = Users object e.g. User(id, balance);
      // to get individual object :  users[uint].id, users[uint].balance


    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

    function updateBalance(uint id, uint balance) public {
         
         // User memory  user = users[id]  // don't use this way as it does not store the balance in the storage or blockchain. The balance will disappear after the function is called.
         // User storage user = users[id]  // correct solution       
         // user.balance = balance;

        // OR 
         users[id].balance = balance;

    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }
 
 }    