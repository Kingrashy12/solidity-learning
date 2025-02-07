// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Calculator {
   uint256 private result = 0;

   function add(uint256 num) public {
    result += num;
   }

   function subtract(uint256 num) public {
    result -= num;
   }

   function mutiplay(uint256 num) public {
    result *= num;
   }

   function get() public view returns (uint256) {
    return result;
   }
}