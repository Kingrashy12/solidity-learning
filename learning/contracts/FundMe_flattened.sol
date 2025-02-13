// SPDX-License-Identifier: MIT
// File: @chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol


pragma solidity ^0.8.0;

// solhint-disable-next-line interface-starts-with-i
interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}

// File: learning/lib/PriceConverter.sol


pragma solidity ^0.8.18;



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
// File: learning/contracts/FundMe.sol


pragma solidity ^0.8.18;


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
        // require(msg.sender == i_owner,"Not authorized!");
        if(msg.sender != i_owner) revert NotOwner();
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