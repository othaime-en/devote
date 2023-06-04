// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// imports go here
// remember to use onlyOwner contract.

/**
 * @title Voting
 * @author Othman Suleyman
 * @notice This contract handles the voting logic
 */
contract Voting {
    // Variables
    address public admin;
    uint public totalVotes;
    uint public numOptions;
    mapping(address => bool) public hasVoted;
    mapping(bytes32 => uint) public voteCount;
    mapping(uint => bytes32) public options;

    // Constructor function
    constructor() {
        admin = msg.sender;
    }

    // Adding a candidate option
    function addOption(bytes32 option) public {
        require(msg.sender == admin, "Only admin can add an option");
        options[numOptions] = option;
        numOptions++;
    }

    // The main voting function
    // Look into possibility of adding a ballot struct
    function vote(uint optionIndex) public {
        require(optionIndex < numOptions, "Invalid option index");
        require(!hasVoted[msg.sender], "Already voted");

        bytes32 option = options[optionIndex];
        voteCount[option]++;
        hasVoted[msg.sender] = true;
        totalVotes++;
    }

    // Get vote count for an option (candidate)
    function getVoteCount(bytes32 option) public view returns (uint) {
        require(option != 0, "Invalid option");
        return voteCount[option];
    }

    // Get option by index
    function getOption(uint index) public view returns (bytes32) {
        require(index < numOptions, "Invalid index");
        return options[index];
    }

    // Get total number of options availlable in a voting instance
    function getNumOptions() public view returns (uint) {
        return numOptions;
    }

    // Remember to add functions: Verifyvote and getOverrallResults

    // function verifyVote() public {}
    // function getOverrallResults() public {}
}
