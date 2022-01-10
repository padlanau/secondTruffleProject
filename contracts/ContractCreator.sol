// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Contract Creator 
 * @author Lodgerio Padlan
 * @dev address that deployed the contract
        - create a constructor. This will be run "ONCE" when this contract is first created/deployed
        - save the msg.sender        

        To test: 
            deploy the contract (using an address)
            call the function createPerson()
            to call deletePerson() function, grab the owner's address and pass it to the deletePerson() function

        It is hard for me to maintain as a contract admin to track all the ones in the mapping. How can I
        delete them? To solve this:
        1. create an address array. Add private so the admin can only access this.
              address[] private creators;
        2. get the address one by one by passing the index of the array address 
              function getCreator(uint index)
        3. once you get the address, you can delete it now by passing the address you get from #2
              deletePerson(address creator) 

 * @notice A simply smart contract to demonstrate :
        - constructor()
        - how to set the address who deployed the contract
        - modifier
        - event AND emit (you will see this in the logs)
        - payable (telling solidity that this function made to receive money.)
        - transfer()
        - send()
        - address payable

        Error Handling
        - require()
                - checks for requirements before invoking function
                - undoes all state changes				 
                - refunds remaining gas to the caller
                - sends return value
        - assert()
                - undoes all state changes		 		 
 			    - but not refunding the gas
 			    - something bad has happened
        - revert() 
                - undoes all state changes
 			    - can send return value to the caller
 			    - refunds remaining gas to the caller
 	


*/

 contract ContractCreator {

    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }

    event personCreated(string name, uint age);
    event personDeleted(string name, uint age, address deletedBy);

    // with index(3 limit as per rule), can easily query
    event personCreatedWithIndex(string indexed name, uint age, address deletedBy);


    address public owner;
    uint public balance; // part of computation if you have payable keyword
                         // to determine smart contract balance. Every time someone creates a person, it adds to this  

    // sample usage in deletePerson2()
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller needs to be owner");
        _;   // means continue the execution if require() is true
    }

    modifier costs(uint cost) {
         require(msg.value >= cost);  
          _; 
    }

    constructor() {
        owner = msg.sender;
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

    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }

    // the difference with insertPerson() is this is using "address payable"
    function insertPerson2(Person memory newPerson) private {
       
        // address creator      = msg.sender;
        // address payable test = creator;   // You can't convert non payable to payable address
        // you need to do this casting:
        // address payable test = address(uint160(creator));
        
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

    // same as withdrawAll() but this one is using send()
    function withdrawAllSend() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;  // need to set to zero as we are withdrawing ALL
        //msg.sender.send(toTransfer);  // https://ethereum.stackexchange.com/questions/66410/understanding-the-send-warning-message
        
        payable(msg.sender).send(toTransfer);   
        // if send() fails, it will return false not REVERT but it will reset the balance to zero
        // use "if" around send() - https://docs.soliditylang.org/en/latest/security-considerations.html

        return toTransfer;
    }

   // the proper way to use send()
    function withdrawAllSendProper() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;  // need to reset to zero as we are withdrawing ALL
      
       
        if (payable(msg.sender).send(toTransfer)){
            //success
            return toTransfer;
        }
        else {
            // failure
            balance = toTransfer;
            return 0; // because we did not return anything
        }         
    }

    


 }    