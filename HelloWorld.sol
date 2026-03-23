
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title HelloWorld - Your very first smart contract
/// @notice Day 1, Lab 1: Deploy this to Remix VM
/// @dev This teaches: pragma, state variables, constructor, functions, view vs state-changing

contract HelloWorld {

    // ── STATE VARIABLE ──
    // Stored permanently on the blockchain
    // "public" auto-generates a getter function (blue button in Remix)
    string public message;

    // ── CONSTRUCTOR ──
    // Runs ONCE at deployment. Sets initial state. Cannot be called again.
    constructor() {
        message = "Mabuhay, Blockchain!";
    }

    // ── FUNCTION: State-changing ──
    // Orange button in Remix = costs gas = writes to blockchain
    // "memory" = temporary storage for the parameter (not saved on-chain)
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }

    // ── FUNCTION: View ──
    // Blue button in Remix = free = reads from blockchain
    // "view" = this function only reads, never writes
    function getMessage() public view returns (string memory) {
        return message;
    }
}


