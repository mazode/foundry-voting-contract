// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Voting.sol";

contract DeployVoting is Script {
    function run() public {
        vm.startBroadcast();

        Voting votingContract = new Voting();

        console.log("Voting contract deployed to: ", address(votingContract));

        vm.stopBroadcast();
    }
}
