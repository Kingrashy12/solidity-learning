// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Twitter {

  uint16 constant MAX_TWEET_LENGTH = 280;

  struct Tweet {
    string content;
    address author;
    uint256 likes;
    uint256 timestamps;
  }

  mapping (address => Tweet[]) public tweets;

  function createTweet(string memory _tweet) public {

    require(bytes(_tweet).length <= MAX_TWEET_LENGTH,"Tweet length is too long");

    Tweet memory newTweet = Tweet({
      author:msg.sender,
      content:_tweet,
      likes:0,
      timestamps:block.timestamp
    });

    tweets[msg.sender].push(newTweet);
  }

  function getTweet(address _owner, uint8 _index) public view returns (Tweet memory) {
    return tweets[_owner][_index];
  }

  function getTweets(address _owner) public view returns (Tweet[] memory) {
    return tweets[_owner];
  }
}