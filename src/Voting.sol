// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Voting {
    event CandidateAdded(string candidateName);
    event VoteCasted(address voter, string candidateName);
    event VotingStarted(uint256 startTime, uint256 endTime);
    event VotingEnded();
    event WinnerDeclared(string winnerName);

    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public owner;
    mapping(address => bool) public hasVoted;
    mapping(string => Candidate) public candidates;
    string[] public candidateList;
    bool public votingOpen;
    uint256 public votingStartTime;
    uint256 public votingEndTime;

    constructor() {
        owner = msg.sender;
        votingOpen = false;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Not the owner");
        _;
    }

    modifier votingIsOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    function startVoting(uint256 _durationInMinutes) public onlyOwner {
        require(!votingOpen, "Voting has already started");
        votingStartTime = block.timestamp;
        votingEndTime = votingStartTime + (_durationInMinutes * 1 minutes);
        votingOpen = true;

        emit VotingStarted(votingStartTime, votingEndTime);
    }

    function addCandidates(string memory _candidateName) public onlyOwner {
        require(!votingOpen, "Cannot add candidates once voting has started");
        require(bytes(candidates[_candidateName].name).length == 0, "Candidate already exists");
        candidates[_candidateName] = Candidate({name: _candidateName, voteCount: 0});
        candidateList.push(_candidateName);

        emit CandidateAdded(_candidateName);
    }

    function castVote(string memory _candidateName) public votingIsOpen {
        require(!hasVoted[msg.sender], "Already casted the vote");
        require(bytes(candidates[_candidateName].name).length > 0, "Candidate not found");

        candidates[_candidateName].voteCount++;

        hasVoted[msg.sender] = true;

        emit VoteCasted(msg.sender, _candidateName);
    }

    function getVoteCount(string memory _candidateName) public view returns (uint256) {
        require(bytes(candidates[_candidateName].name).length > 0, "Candidate not found");
        return candidates[_candidateName].voteCount;
    }

    function endVoting() public onlyOwner {
        require(votingOpen, "Voting has ended");
        require(block.timestamp > votingEndTime, "Voting period has not ended yet");
        votingOpen = false;

        emit VotingEnded();
    }

    function getWinner() public returns (string memory winnerName) {
        require(!votingOpen, "Voting is still open");
        require(block.timestamp > votingEndTime, "Voting period has not ended yet");
        uint256 highestVoteCount = 0;
        for (uint256 i = 0; i < candidateList.length; i++) {
            string memory candidateName = candidateList[i];
            if (candidates[candidateName].voteCount > highestVoteCount) {
                highestVoteCount = candidates[candidateName].voteCount;
                winnerName = candidateName;
            }
        }
        require(bytes(winnerName).length > 0, "Candidate not found");

        emit WinnerDeclared(winnerName);
    }

    function getRemainingTime() public view returns (uint256) {
        if (!votingOpen || block.timestamp >= votingEndTime) {
            return 0;
        }
        return votingEndTime - block.timestamp;
    }
}
