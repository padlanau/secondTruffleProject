// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Solidity data types
 * @author Lodgerio Padlan
 * @dev data types 
 * @notice A simply smart contract to demonstrate simple data types available in Solidity
 */
contract DataTypesAndDataLocation {
 
  /*
      address  
  */

  address owner = msg.sender; // msg.sender is the Ethereum address of the account that sent this transaction

  /*
    uint:
        unsigned can be 0 or greater 
        stores non-negative integers
        good for counting
        automatically 256-bit integer
        can define a smaller size, uint8 which stores only 8 bits
  */
    uint  u  = 1;
    uint8 u8 = 8;
    uint public up = 33;

  /*
    int: can store negative 
  */

    int i = -11; 
        
  /*
    bool: 
  */
    bool isEthereumCool = true; 
    bool public isNewYear = true;

  /*
    bytes32: 
        decomposing of strings of characters is easier than a string 
  */
  
    bytes32 bMsg = "hello";

  /*
    data location 
      // storage 
            - state variables
            - blockchain data
    		    - must pay money to store on the blockchain
            - saves permanently, persistently

      // memory
            - local variable
			      - lives in other local memory (EVM) not the stack	
            - saves only during the function execution 
            - all function parameters are defaulted to "memory" except for complex types like string and structs
              we need to define their data location 

               function createPersonByArray(string memory name, uint age, uint height) {
                 
               }
    
               Person memory newPerson;  // newPerson objects will be deleted after execution of the function()
               string memory message = "Hi";  // message will be deleted after execution of the function()

               ... returns(string memory) 

      // calldata
            - like memory but read only
      // stack
            - simple variable like an integer
			      - lives in local memory in the EVM

  */
  
    


  /*
    mapping: Key ==> Value
    make it private so solidity will not create getter() and only this contract can access it.
  */

    mapping(address => PersonWithMapping) private peopleMap;  // input the address and returns the exact Person back

        // read : address of PersonWithMapping objects  

        // to save                  :  peopleMap[address] = PersonWithMapping object
        // to get individual object :  peopleMap[address].name, peopleMap[address].age, peopleMap[address].height

  /*
    string: 
  */

    string sMsg = "hello"; 

  /*
    dynamic array []: can use 'push' function
  */

    uint[]   public numbers  = [1, 21, 46];
    string[] public messages = ["hello", "hello new year", "hello love"];

   

  /*
    fixed array [x]: can't use 'push' function
  */

    uint[3]   public sizes  = [1, 50, 100];


  /*
   struct
  */

    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
    }

   // id is not needed in Mapping, only add the address 
   struct PersonWithMapping {
        string name;
        uint age;
        uint height;      
    
    }


    // functions

    function getStateVariables() public view returns (uint, int, uint, bool, address, bytes32, string memory) {
        return (u, i, u8, isEthereumCool, owner, bMsg, sMsg); 
    }

    // get the value of an array based on index given
    // index here must be in uint, bec index can't be negative(dont use int)
    function getNumber(uint index) public view returns(uint) {
        return numbers[index];
    }

    // get all array values
    function getNumberS() public view returns(uint[] memory) {
        return numbers;
    }


    // update a value of an array
    function setNumber(uint newNumber, uint index) public {
        numbers[index] = newNumber;
    }

   // this will add(push) the new number at the end of the array. So no need to add an index
    function addNumber(uint newNumber) public {
        numbers.push(newNumber);
 
    }

    // create an instance of the Person object
    Person[] public people;

    function createPersonByArray(string memory name, uint age, uint height) public{
        // people.length is used to get the new index
       
        Person memory newPerson;
        newPerson.id = people.length;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        people.push(newPerson);

        // OR

        // people.push(Person(people.length, name, age, height));

    }

    
    function createPersonByMapping(string memory name, uint age, uint height) public {
        // if you have a parameter "address creator," on this function, as a user, you will input the address
        // but what if that is incorrect? You will lose it forever. So the trick here is to create a variable
        // called address and assign msg.sender
        address creator = msg.sender;
       
        PersonWithMapping memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        peopleMap[creator] = newPerson;

    }

    //function getPerson() public returns(PersonWithMapping memory) {
    // OR     
    function getPerson() public view returns(string memory name, uint age, uint height) {
        
        address creator = msg.sender;
        peopleMap[creator]; 
        // OR
        // peopleMap[msg.sender]  // address of the user 

        return (peopleMap[creator].name, peopleMap[creator].age, peopleMap[creator].height);

    }


 

}