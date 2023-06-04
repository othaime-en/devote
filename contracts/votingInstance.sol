// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Voting.sol";

/**
 * @title VotingInstance
 * @author Othman Suleyman
 * @notice This is part of the main application logic
 * @notice It inherits the voting logic from Voting.sol and implements it in every voting instance.
 * @notice
 */
contract VotingInstance is Voting {
    // Restructure this to be the ballot struct and add functionalities
    struct Voter {
        bool voted;
        uint vote;
    }

    struct VoteInstance {
        string name;
        mapping(address => Voter) voters;
        uint[] voteCount;
        bool closed;
    }

    mapping(string => VoteInstance) public voteInstances;
    string[] public instanceNames;

    // Create a new voting instance
    // Takes in the name and the number of options for the voting instance
    function createVoteInstance(string memory name, uint numOptions) public {
        require(bytes(name).length > 0, "Name cannot be empty.");
        require(numOptions > 0, "Number of options must be greater than zero.");
        // require(
        //     voteInstances[name].closed,
        //     "Vote instance with this name already exists."
        // );

        VoteInstance storage vi = voteInstances[name];
        vi.name = name;
        vi.voteCount = new uint[](numOptions);
        instanceNames.push(name);
    }

    // Vote on an instance
    // Takes the name of the instance and the candidate option
    function voteOnInstance(string memory name, uint option) public {
        VoteInstance storage vi = voteInstances[name];
        require(!vi.closed, "Vote instance is closed.");
        Voter storage sender = vi.voters[msg.sender];
        require(!sender.voted, "Already voted.");
        require(option < vi.voteCount.length, "Invalid option.");
        sender.voted = true;
        sender.vote = option;
        vi.voteCount[option] += 1;
    }

    // Close vote instance
    // Should have access restrictions
    // Only the creator of the instance is allowed to close the instance
    function closeVoteInstance(string memory name) public {
        VoteInstance storage vi = voteInstances[name];
        require(!vi.closed, "Vote instance is already closed.");
        vi.closed = true;
    }

    // Get names for all current voting instance
    function getInstanceNames() public view returns (string[] memory) {
        return instanceNames;
    }
}
