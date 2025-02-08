// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Twitter {

  struct Tweet {
    uint256 id;
    string content;
    address author;
    uint256 likes;
    uint256 timestamps;
  }

  uint16 public MAX_TWEET_LENGTH = 280;
  mapping (address => Tweet[]) tweets;
  address public owner;

  constructor(){
    owner = msg.sender;
  }

  modifier onlyOwner(){
    require(owner == msg.sender,"You are not the owner");
    _;
  }

  function changeTweetLength(uint16 newLength) public onlyOwner {
   MAX_TWEET_LENGTH = newLength;
  }


  function createTweet(string memory _tweet) public  {

    require(bytes(_tweet).length <= MAX_TWEET_LENGTH,"Tweet length is too long");

    Tweet memory newTweet = Tweet({
      id: tweets[msg.sender].length,
      author:msg.sender,
      content:_tweet,
      likes:0,
      timestamps:block.timestamp
    });

    tweets[msg.sender].push(newTweet);
  }

  function getTweet(address _owner, uint8 _index) public  view returns (Tweet memory) {
    return tweets[_owner][_index];
  }

  function getTweets(address _owner) public  view returns (Tweet[] memory) {
    return tweets[_owner];
  }

}