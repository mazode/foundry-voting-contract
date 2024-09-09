// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract TestVoting is Test {
    Voting voting;
    uint256 public initialTime;

    function setUp() public {
        voting = new Voting();
        initialTime = block.timestamp;
    }

    function testInitialState() public {
        assertEq(voting.owner(), address(this), "Owner should be test contract");
        assertEq(voting.votingOpen(), false, "Voting should initially be closed");
    }

    function testStartVoting() public {
        voting.startVoting(60); // 60 minutes voting period
        assertEq(voting.votingOpen(), true, "Voting should be open after starting");
        assertEq(voting.votingStartTime(), initialTime, "Start time should be set correctly");
        assertEq(voting.votingEndTime(), initialTime + 60 minutes, "End time should be set correctly");
    }

    function testAddCandidate() public {
        voting.addCandidates("Candidate 1");
        assertEq(voting.candidateList(0), "Candidate 1", "Should add candidate correctly");
    }

    function testCannotAddDuplicateCandidate() public {
        voting.addCandidates("Candidate 1");
        vm.expectRevert("Candidate already exists");
        voting.addCandidates("Candidate 1");
    }

    function testCannotStartVotingTwice() public {
        voting.startVoting(60);
        vm.expectRevert("Cannot add candidates once voting has started");
        voting.addCandidates("Candidate 2");
    }

    function testCastVote() public {
        voting.addCandidates("Candidate 1");
        voting.startVoting(60);
        voting.castVote("Candidate 1");
        assertEq(voting.getVoteCount("Candidate 1"), 1, "Vote count should increase after casting a vote");
    }

    function testCannotVoteTwice() public {
        voting.addCandidates("Candidate 1");
        voting.startVoting(60);
        voting.castVote("Candidate 1");
        vm.expectRevert("Already casted the vote");
        voting.castVote("Candidate 1");
    }

    function testCannotVoteForNonExistantCandidate() public {
        voting.startVoting(60);
        vm.expectRevert("Candidate not found");
        voting.castVote("Non existant candidate");
    }

    function testEndVoting() public {
        voting.startVoting(0);
        vm.warp(initialTime + 1 minutes);
        voting.endVoting();
        assertEq(voting.votingOpen(), false, "Voting is closed after ending");
    }

    function testCannotEndVotingBeforePeriodEnds() public {
        voting.startVoting(60);
        vm.expectRevert("Voting period has not ended yet");
        voting.endVoting();
    }

    function testGetWinner() public {
        voting.addCandidates("Candidate 1");
        voting.addCandidates("Candidate 2");
        voting.startVoting(0);
        voting.castVote("Candidate 1");

        vm.warp(initialTime + 1 minutes);
        voting.endVoting();
        string memory winner = voting.getWinner();
        assertEq(winner, "Candidate 1", "Winner should be candidate 1");
    }

    function testGetRemainingTimeBeforeVoting() public {
        uint256 remainingTime = voting.getRemainingTime();
        assertEq(remainingTime, 0, "Remaning time should be 0 before voting begins");
    }
}
