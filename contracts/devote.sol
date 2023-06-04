//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DecentralizedVoting1 {
    struct VotingInstance {
        uint256 id;
        string name;
        address creator;
        mapping(uint256 => Candidate) candidates;
        uint256 candidateCount;
    }

    struct Candidate {
        uint256 id;
        string name;
        string role;
        string description;
        uint256 voteCount;
    }

    uint256 public instanceId;
    mapping(uint256 => VotingInstance) public instances;

    event VotingInstanceCreated(uint256 id, string name, address creator);
    event CandidateAdded(
        uint256 instanceId,
        uint256 candidateId,
        string candidateName,
        string candidateRole,
        string candidateDescription
    );
    event VoteCasted(uint256 instanceId, uint256 candidateId, address voter);

    function createInstance(string memory _name) public {
        VotingInstance storage instance = instances[++instanceId];
        instance.id = instanceId;
        instance.name = _name;
        instance.creator = msg.sender;
        emit VotingInstanceCreated(instanceId, _name, msg.sender);
    }

    function addCandidate(
        uint256 _instanceId,
        string memory _candidateName,
        string memory _candidateRole,
        string memory _candidateDescription
    ) public {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        require(
            msg.sender == instance.creator,
            "Only the creator can add candidates"
        );

        uint256 candidateId = instance.candidateCount + 1;
        instance.candidates[candidateId] = Candidate({
            id: candidateId,
            name: _candidateName,
            role: _candidateRole,
            description: _candidateDescription,
            voteCount: 0
        });
        instance.candidateCount++;
        emit CandidateAdded(
            _instanceId,
            candidateId,
            _candidateName,
            _candidateRole,
            _candidateDescription
        );
    }

    function vote(uint256 _instanceId, uint256 _candidateId) public {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        require(
            _candidateId <= instance.candidateCount,
            "Invalid candidate ID"
        );

        instance.candidates[_candidateId].voteCount++;
        emit VoteCasted(_instanceId, _candidateId, msg.sender);
    }

    function getCandidateVotes(
        uint256 _instanceId,
        uint256 _candidateId
    ) public view returns (uint256) {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        require(
            _candidateId <= instance.candidateCount,
            "Invalid candidate ID"
        );

        return instance.candidates[_candidateId].voteCount;
    }

    function getCandidateCount(
        uint256 _instanceId
    ) public view returns (uint256) {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        return instance.candidateCount;
    }

    function getOverallResults(
        uint256 _instanceId
    )
        public
        view
        returns (uint256[] memory, string[] memory, uint256[] memory)
    {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        uint256[] memory candidateIds = new uint256[](instance.candidateCount);
        string[] memory candidateNames = new string[](instance.candidateCount);
        uint256[] memory voteCounts = new uint256[](instance.candidateCount);

        for (uint256 i = 0; i < instance.candidateCount; i++) {
            uint256 candidateId = i + 1;
            candidateIds[i] = candidateId;
            candidateNames[i] = instance.candidates[candidateId].name;
            voteCounts[i] = instance.candidates[candidateId].voteCount;
        }

        return (candidateIds, candidateNames, voteCounts);
    }

    function getCandidate(
        uint256 _instanceId,
        uint256 _candidateId
    )
        public
        view
        returns (uint256, string memory, string memory, string memory, uint256)
    {
        require(_instanceId <= instanceId, "Invalid instance ID");
        VotingInstance storage instance = instances[_instanceId];
        require(
            _candidateId <= instance.candidateCount,
            "Invalid candidate ID"
        );
        Candidate storage candidate = instance.candidates[_candidateId];
        return (
            candidate.id,
            candidate.name,
            candidate.role,
            candidate.description,
            candidate.voteCount
        );
    }

    function getOpenInstances()
        public
        view
        returns (
            uint256[] memory,
            string[] memory,
            address[] memory,
            uint256[] memory,
            uint256[][] memory,
            string[][] memory,
            string[][] memory,
            uint256[][] memory
        )
    {
        uint256[] memory instanceIds = new uint256[](instanceId);
        string[] memory instanceNames = new string[](instanceId);
        address[] memory instanceCreators = new address[](instanceId);
        uint256[] memory instanceCandidateCounts = new uint256[](instanceId);
        uint256[][] memory instanceCandidateIds = new uint256[][](instanceId);
        string[][] memory instanceCandidateNames = new string[][](instanceId);
        string[][] memory instanceCandidateRoles = new string[][](instanceId);
        uint256[][] memory instanceCandidateVoteCounts = new uint256[][](
            instanceId
        );

        for (uint256 i = 1; i <= instanceId; i++) {
            instanceIds[i - 1] = i;
            instanceNames[i - 1] = instances[i].name;
            instanceCreators[i - 1] = instances[i].creator;
            instanceCandidateCounts[i - 1] = instances[i].candidateCount;

            instanceCandidateIds[i - 1] = new uint256[](
                instances[i].candidateCount
            );
            instanceCandidateNames[i - 1] = new string[](
                instances[i].candidateCount
            );
            instanceCandidateRoles[i - 1] = new string[](
                instances[i].candidateCount
            );
            instanceCandidateVoteCounts[i - 1] = new uint256[](
                instances[i].candidateCount
            );

            for (uint256 j = 1; j <= instances[i].candidateCount; j++) {
                instanceCandidateIds[i - 1][j - 1] = instances[i]
                    .candidates[j]
                    .id;
                instanceCandidateNames[i - 1][j - 1] = instances[i]
                    .candidates[j]
                    .name;
                instanceCandidateRoles[i - 1][j - 1] = instances[i]
                    .candidates[j]
                    .role;
                instanceCandidateVoteCounts[i - 1][j - 1] = instances[i]
                    .candidates[j]
                    .voteCount;
            }
        }

        return (
            instanceIds,
            instanceNames,
            instanceCreators,
            instanceCandidateCounts,
            instanceCandidateIds,
            instanceCandidateNames,
            instanceCandidateRoles,
            instanceCandidateVoteCounts
        );
    }
}
