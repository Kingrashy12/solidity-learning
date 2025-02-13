// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "../lib/PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;
    address ETHUSD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    uint256 minimumUsd = 5e18;
    address[] funders;
    mapping (address => uint256) public addressToAmountFounded;

    function fund() public payable  {
        require(msg.value.getConversationRate(ETHUSD) >= minimumUsd,"You can't send below $5");
        funders.push(msg.sender);
        addressToAmountFounded[msg.sender] += msg.value;
    }

    function withdraw() public {
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFounded[funder] = 0;
        }
    }
}