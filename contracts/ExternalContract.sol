// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  External  
 * @author Lodgerio Padlan
 * @dev    Information needed to use external smart contracts:
            1. address of the contract we need to interact with
            2. the smart contract's location
            3. Our sample here is to call the function "createPerson(string memory name, uint age, uint height) public payable"
              from ContractCreator.sol

           Steps:
            1. create ExternalContract.sol (this one)
            2. create function externalCreatePerson() and copy the parameters from ContractCreator.createPerson 
            3. see below
            4. see below
            5. see below    

 * @notice A simply smart contract to demonstrate :
           contract to contract interaction
           get values from other contract, etc 
           
*/


// Interface
// 4. provide the definitions/headers of the smart contract and the function we want to call
//    no need to include the modifier e.g. costs(1 ether) if you have one

    contract ContractCreator{
        function createPerson2(string memory name, uint age, uint height) public payable;
    }


 contract ExternalContract {

     // 3. get the ContractCreator's contract address
     ContractCreator cc = ContractCreator(0xd9145CCE52D386f254917e481eB44e9943F39138);

    function externalCreatePerson(string memory name, uint age, uint height) public payable {
        // 5. CALL createPerson from ContractCreator.sol AND forward any ether
        // cc.createPerson(name, age, height);  // this will be enough if you dont need to send any money
         cc.createPerson2.value(msg.value)(name, age, height);  
    }

}
