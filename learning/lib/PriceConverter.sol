// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {

     function getPrice(address _contractAddress) internal view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_contractAddress);
        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversationRate(uint256 ethAmount, address _contractAddress) internal view returns (uint256){
        uint256 ethPrice = getPrice(_contractAddress);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}