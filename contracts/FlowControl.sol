// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title  Solidity data types
 * @author Lodgerio Padlan
 * @dev program flow
 * @notice A simply smart contract to demonstrate simple flow available in Solidity
 */

 contract FlowControl {
 
    function count(int number) public pure returns(int) {
      int i = 0;

      while(i < 10) {
         number++;
         i++; 
      }
        return number;
    }


     function calculateDozenDiscountIF(uint purchasedQty) private pure returns(bool) {
         bool giveDozenPrice = false;

         if(purchasedQty >= 12)
            giveDozenPrice = true;

        // or remove the following as the default value is false (for demo purposes only)  
         else if(purchasedQty == 0) {
              giveDozenPrice = false;
         }   

         else
            giveDozenPrice = false;


          return (giveDozenPrice);      
     }
 
  function calculateDozenDiscountWHILE(uint purchasedQty) private pure returns(bool) {
         bool giveDozenPrice = false;
         uint numDonuts = 1;

         while (numDonuts < purchasedQty) {
             numDonuts++;

            if (numDonuts >= 12) {
                giveDozenPrice = true;
                break;
            }
         }
        return (giveDozenPrice);
     }
 
   function calculateDozenDiscountFOR(uint purchasedQty) private pure returns(bool) {
         bool giveDozenPrice = false;
         uint numDonuts = 1;
          
         for (numDonuts = 1; numDonuts <= purchasedQty; numDonuts++)  {
              giveDozenPrice = true;
              break;
         } 
       return (giveDozenPrice);
     }
 
  function countFOR(int number) public pure returns(int) {
                  
         for (int i = 0; i < 10; i++)  {
              number++;             
         } 
       return number;
     }

    


}