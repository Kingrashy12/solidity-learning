// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { PriceConverter } from "../lib/PriceConverter.sol";

contract FundMe {
    
    using PriceConverter for uint256;

    uint public minimumUSD = 5e18;
    address[] public founders;
    mapping (address => uint256) public addressToAmountFounded;

    address ETHUSD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function fund() public payable {
     require(msg.value.getConversationRate(ETHUSD) >= minimumUSD,"Please send mimimun ETH");
     founders.push(msg.sender);
     addressToAmountFounded[msg.sender] = addressToAmountFounded[msg.sender] + msg.value;
    }

   

}