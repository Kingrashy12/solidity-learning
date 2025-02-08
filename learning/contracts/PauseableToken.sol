// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PauseableToken {
    address public owner;
    bool public paused;
    mapping (address => uint) public balances;

    constructor(){
        owner = msg.sender;
        paused = false;
        balances[msg.sender] = 1000;
    }

    modifier onlyOwner(){
        require(owner == msg.sender,"You're not the contract owner");
        _;
    }

    modifier notPaused(){
        require(paused == false,"The Contract is paused");
        _;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

   function transfer(address to, uint amount) public notPaused {
    require(msg.sender != to,"You can send to yourself");
    require(balances[msg.sender] >= amount,"Insufficient balance");

    balances[msg.sender] -= amount;
    balances[to] += amount;
   }
 
}