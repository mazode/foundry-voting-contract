# Voting Contract

## Overview

A smart contract for managing and conducting voting events on Ethereum. It allows adding candidates, casting votes, and determining the winner.

## Features

- **Add Candidates**: Owner can add candidates before voting starts.
- **Start Voting**: Owner can start voting for a specified duration.
- **Cast Votes**: Users can cast their votes during the voting period.
- **End Voting**: Owner can end the voting period.
- **Get Winner**: Determine the candidate with the most votes after voting ends.
- **Check Remaining Time**: See how much time is left for voting.

## Functions

- `startVoting(uint256 _durationInMinutes)`: Starts the voting process with a specified duration.
- `addCandidates(string memory _candidateName)`: Adds a candidate (owner only).
- `castVote(string memory _candidateName)`: Allows users to vote for a candidate (during voting).
- `getVoteCount(string memory _candidateName)`: Retrieves the vote count for a specific candidate.
- `endVoting()`: Ends the voting process (owner only).
- `getWinner()`: Retrieves the winner after voting ends.
- `getRemainingTime()`: Gets the remaining time in seconds for the ongoing voting period.

## Events

- `CandidateAdded(string candidateName)`: Emitted when a new candidate is added.
- `VoteCasted(address voter, string candidateName)`: Emitted when a vote is cast.
- `VotingStarted(uint256 startTime, uint256 endTime)`: Emitted when voting starts.
- `VotingEnded()`: Emitted when voting ends.
- `WinnerDeclared(string winnerName)`: Emitted when the winner is declared.

## Usage

1. **Deploy**: Deploy the contract using Foundry.
2. **Add Candidates**: Use `addCandidates` before starting voting.
3. **Start Voting**: Use `startVoting` to begin the voting process.
4. **Cast Votes**: Use `castVote` during the voting period.
5. **End Voting**: Use `endVoting` to close voting.
6. **Get Winner**: Use `getWinner` to determine the winner after voting ends.
7. **Check Remaining Time**: Use `getRemainingTime` to see the time left for voting.
