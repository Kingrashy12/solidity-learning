// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConverter } from "../lib/PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    address constant ETHUSD = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    address constant ETHUSD_ZK = 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF;
    uint256 public constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping (address => uint256) public addressToAmountFounded;
    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner,"Not authorized!");
        // if(msg.sender != i_owner) revert NotOwner();
        _;
    }

    function fund() public payable  {
        require(msg.value.getConversationRate(ETHUSD_ZK) >= MINIMUM_USD,"You can't send below $5");
        funders.push(msg.sender);
        addressToAmountFounded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for(uint256 funderIndex; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFounded[funder] = 0;
        }
        funders = new address[](0);

    // // transfer
    //    payable(msg.sender).transfer(address(this).balance); 
    // // send
    //    bool sendSuccess = payable(msg.sender).send(address(this).balance);
    //    require(sendSuccess,"Send failed");
     
    // call
    (bool callSuccess,) = payable(i_owner).call{value: address(this).balance}(""); 
    require(callSuccess,"Call failed");
    }

    receive() external payable { fund(); }

    fallback() external payable { fund(); }
}