import "./Ownable.sol";
import "./Destroyable.sol";


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Inheritance  
 * @author Lodgerio Padlan
 * @dev    reduce code duplication
           inheriting from Ownable.sol or extends the functionality from it
 * @notice A simply smart contract to demonstrate inheritance
           To deploy this, only the Inheritance.sol needs to be deployed 
 	
*/

 contract Inheritance is Ownable, Destroyable {

   struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }

    event personCreated(string name, uint age);
    event personDeleted(string name, uint age, address deletedBy);

 
    uint public balance; // part of computation if you have payable keyword
                         // to determine smart contract balance. Every time someone creates a person, it adds to this  

    modifier costs(uint cost) {
         require(msg.value >= cost);  
          _; 
    }

    mapping (address => Person) private people;
    address[] private creators;

    function createPerson(string memory name, uint age, uint height) public payable {
      require(age < 120, "Age needs to be below 120");  // you can limit a persons age to be added

      // the following is required if you have payable keyword  
      require(msg.value >= 1 ether, "Value must be 1 ether or more");  
      // you can use wei. This function cost 1 ether to run
      // in Remix, enter 1 in the Value box  
      balance += msg.value;  // it is saving the Value each time someone creates a person



        //This creates a person
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;

        if(age >= 65){
           newPerson.senior = true;
       }
       else{
           newPerson.senior = false;
       }

        insertPerson(newPerson);
        creators.push(msg.sender); // this will add an entry to the array of the address of the user  

        // we need to make sure that the newPerson object created above 
        // to compare, hash it
        assert(keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].height, people[msg.sender].senior)) == 
               keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.height, newPerson.senior)));
        
        emit personCreated(newPerson.name, newPerson.age);

    }

    // createPerson2 is same as createPerson() except I used the modifier costs() here
    function createPerson2(string memory name, uint age, uint height) public payable costs(1 ether) {
      require(age < 120, "Age needs to be below 120");  // you can limit a persons age to be added

      balance += msg.value;  // it is saving the Value each time you create a person

      // ...  

    }

    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }
 

    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }

    // only the owner of the contract can delete a person
    function deletePerson(address creator) public {
       require(msg.sender == owner, "Caller needs to be owner");
       
       string memory name = people[creator].name;
       uint edad = people[creator].age;
       
       delete people[creator];
       
       assert(people[creator].age == 0); // once you delete it from the map, it resets its value
     
       // emit personDeleted(people[creator].name, people[creator].age, owner);   // you can't do the following because you already deleted the object. You need to save it first (see name, edad)
       emit personDeleted(name, edad, owner); 

   }

    // sample usage of a modifier
    function deletePerson2(address creator) public onlyOwner {      
       delete people[creator];
       
       assert(people[creator].age == 0); // once you delete it from the map, it resets its value
   }


    // only the owner of the contract can delete a person
   function getCreator(uint index) public view returns(address){
       require(msg.sender == owner, "Caller needs to be owner");
       return creators[index];
   }

    // withdraw ALL from the balance gathered using transfer()
    function withdrawAll() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;  // need to reset to zero as we are withdrawing ALL
        //msg.sender.transfer(toTransfer); // https://stackoverflow.com/questions/68121086/typeerror-send-and-transfer-are-only-available-for-objects-of-type-address
        payable(msg.sender).transfer(toTransfer);  // if this fails, throws an error and it will REVERT and resetting the balance to zero will not take place.

        return toTransfer;
    }

   

    
 }    