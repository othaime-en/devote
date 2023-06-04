// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CombinedVoting {
    // Variables
    address public admin;
    uint public totalVotes;
    mapping(address => bool) public hasVoted;
    mapping(bytes32 => uint) public voteCount;
    mapping(uint => bytes32) public options;
    uint public numOptions;

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

    // Constructor
    constructor() {
        admin = msg.sender;
    }

    // Add option
    function addOption(bytes32 option) public {
        require(msg.sender == admin, "Only admin can add option");
        options[numOptions] = option;
        numOptions++;
    }

    // Vote
    function vote(uint optionIndex) public {
        require(optionIndex < numOptions, "Invalid option index");
        require(!hasVoted[msg.sender], "Already voted");

        bytes32 option = options[optionIndex];
        voteCount[option]++;
        hasVoted[msg.sender] = true;
        totalVotes++;
    }

    // Get vote count for an option
    function getVoteCount(bytes32 option) public view returns (uint) {
        require(option != 0, "Invalid option");
        return voteCount[option];
    }

    // Get option by index
    function getOption(uint index) public view returns (bytes32) {
        require(index < numOptions, "Invalid index");
        return options[index];
    }

    // Get total number of options
    function getNumOptions() public view returns (uint) {
        return numOptions;
    }

    // Create a voting instance
    function createVoteInstance(string memory name, uint numOptions2) public {
        require(bytes(name).length > 0, "Name cannot be empty.");
        require(
            numOptions2 > 0,
            "Number of options must be greater than zero."
        );
        require(
            voteInstances[name].closed,
            "Vote instance with this name already exists."
        );

        VoteInstance storage vi = voteInstances[name];
        vi.name = name;
        vi.voteCount = new uint[](numOptions2);
        instanceNames.push(name);
    }

    // Vote on an instance
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
    function closeVoteInstance(string memory name) public {
        VoteInstance storage vi = voteInstances[name];
        require(!vi.closed, "Vote instance is already closed.");
        vi.closed = true;
    }

    // Get instance names
    function getInstanceNames() public view returns (string[] memory) {
        return instanceNames;
    }
}
