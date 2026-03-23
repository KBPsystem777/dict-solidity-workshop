// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @title PermitRegistry v1 - Day 1 Capstone
/// @notice Teaches: data types, visibility (RA 10173), constructor, require(), events
/// @dev Participants build this from scratch in the last hour of Day 1

contract PermitRegistry {
    // ── STATE VARIABLES ──
    // Each variable's visibility is a deliberate RA 10173 decision

    string public holderName; // PUBLIC: transparency — anyone can verify the holder
    uint256 public permitNumber; // PUBLIC: reference number, not sensitive
    address internal issuingOfficer; // INTERNAL: officer identity, visible to child contracts only
    bool public isActive; // PUBLIC: permit status should be verifiable

    // Why not "private" for issuingOfficer?
    // → "internal" lets child contracts (Day 3 inheritance) access it
    // → "private" would block inheritance. Design decision.

    // Counter for auto-incrementing permit numbers
    uint256 private permitCounter;

    // ── EVENT ──
    // Logged permanently on-chain. COA can query this.
    event PermitIssued(
        string holderName,
        uint256 permitNumber,
        address indexed officer,
        uint256 timestamp
    );

    // ── CONSTRUCTOR ──
    // The deployer becomes the issuing officer
    constructor() {
        issuingOfficer = msg.sender;
        permitCounter = 0;
    }

    // ── FUNCTION: Issue a permit ──
    // Three require() rules — each one is unbreakable
    function issuePermit(string memory _name) public {
        // RULE 1: Only the officer can issue
        require(
            msg.sender == issuingOfficer,
            "Only the issuing officer can issue permits"
        );

        // RULE 2: Name cannot be empty
        require(bytes(_name).length > 0, "Holder name is required");

        // RULE 3: Cannot issue if already active
        require(!isActive, "A permit is already active");

        // All rules passed → execute
        permitCounter++;
        holderName = _name;
        permitNumber = permitCounter;
        isActive = true;

        // Log the event
        emit PermitIssued(_name, permitCounter, msg.sender, block.timestamp);
    }

    // ── VIEW FUNCTIONS ──
    // Free to call (blue buttons)
    function getPermitStatus() public view returns (bool) {
        return isActive;
    }

    function getPermitHolder() public view returns (string memory) {
        return holderName;
    }

    // ── DEACTIVATE ──
    // Only officer can deactivate
    function deactivatePermit() public {
        require(msg.sender == issuingOfficer, "Only the issuing officer");
        require(isActive, "Permit is not active");
        isActive = false;
    }
}

// ╔══════════════════════════════════════════════════════════════╗
// ║  FACILITATOR SCRIPT:                                         ║
// ║  1. Ask the room: "For each field, public or private?"       ║
// ║  2. Discuss RA 10173: PhilSys ID → private. Permit → public  ║
// ║  3. Build live. Let THEM tell you the visibility.            ║
// ║  4. Deploy. Call issuePermit("Juan dela Cruz").              ║
// ║  5. Try calling from Account 2 → watch it revert.            ║
// ║  6. "That require() just stopped an unauthorized issuance."  ║
// ╚══════════════════════════════════════════════════════════════╝
