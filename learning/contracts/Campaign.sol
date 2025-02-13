// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Campaign {
    struct Event {
        bool active;
        uint256 start_date;
        uint256 end_date;
        address[] participants;
        uint256 id;
        uint256 created_at;
        address created_by;
    }

    mapping(address => Event[]) public participated;
    address public owner;
    address[] public admins;
    Event public current;
    bool public paused;
    Event[] all_campaign;

    constructor() {
        owner = msg.sender;
        paused = false;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "You are not authorized to carry out this action"
        );
        _;
    }

    modifier notPaused() {
        require(paused == false, "The Contract is paused");
        _;
    }

    function pause() public onlyOwner {
        require(
            current.active == false,
            "Can't pause contract while there's an active event"
        );

        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    function addAdmin(address _admin) public onlyOwner {
        admins.push(_admin);
    }

    function getCampaigns() public view returns (Event[] memory) {
        return all_campaign;
    }

    function createCampaign(uint256 start, uint256 end) public onlyOwner {
       require(current.active == false,"Please wait for the current campaign to end");

        address[] memory participants;
        Event memory new_campaign = Event({
            created_by: msg.sender,
            active: true,
            id: all_campaign.length + 1,
            created_at: block.timestamp,
            participants:participants,
            start_date: start,
            end_date: end
        });

        all_campaign.push(new_campaign);
        current = new_campaign;
    }

    function getCampaign(uint256 index) public view returns (Event memory) {
        return all_campaign[index];
    }

    function partake () public {
         bool hasPartake = false;
         address[] storage inEvent = current.participants;

        for (uint i; i < inEvent.length; i++) {
          if (inEvent[i] == msg.sender) {
            hasPartake = true;
          }else hasPartake = false;
        }

       require(hasPartake == false,"You have already partaken");

       participated[msg.sender].push(current);
       inEvent.push(msg.sender);
    }

    function getParticipants(uint256 index) public view returns (address[] memory) {
     return all_campaign[index].participants;
    }
}
