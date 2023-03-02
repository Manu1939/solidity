// CCMP 606 Assignment 1
// Piggy Bank Smart Contract
// Author: Manpreet Kaur

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// My contract address:  0xdf1eACAaB9B9DbBB8D146DB6Aff83331C30493Df

contract PiggyBank {

    address public immutable owner;
    mapping (address => uint256) deposits;
    // Set up so that the owner is the person who deployed the contract.
    constructor() {
        owner = msg.sender;
    }

    // Set a savings goal 
    // Set any other variables you need
    uint public totalAmount;
    uint public savingGoal;

    function setSavingGoal(uint _savingAmountGoal)public{
        savingGoal=_savingAmountGoal;

    }
    // Create an event to emit once you reach the savings goal 
     
      event SavingsGoalReached(address indexed sender,string message);

    // Function to receive ETH, called depositToTheBank
    // -- Function should log who sent the ETH 
    event Log(address indexed sender, string message);
    function depositToTheBank(uint amount) public payable {
         require(msg.value == amount, "Amount must be equal to the sent ether.");
        deposits[msg.sender] += amount;
        totalAmount += amount;
        
         emit Log(msg.sender,"has sent ETH");

       if (totalAmount >= savingGoal) {
            emit SavingsGoalReached(msg.sender,"goal has completed");
        }

    }

    // Function to return the balance of the contract, called getBalance which returns the balance in Wei
    // -- 1 Eth = 1 * 10**18 Wei

    function getBalance() public view returns (uint256) {
    return address(this).balance;
}

    // Function to look up how much any depositor has deposited, called getDepositsValue
    function getDepositsValue(address depositor) public view returns (uint) {
    return deposits[depositor];
  }

    // Function to withdraw (send) ETH, called emptyTheBank
    // -- Only the owner should be able to empty the bank
    
    function  emptyTheBank() public {
        require(msg.sender==owner,"only owner can do this");
        uint amount = address(this).balance;

        (bool success, ) = owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }
}
