// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./PerpetualsTradingContract.sol";

/*
 * @title PerpetualsTradingContractFactory
 * @dev Factory contract for creating new instances of PerpetualsTradingContract.
 * Each instance can represent a separate market or trading pair.
 */

contract PerpetualsTradingContractFactory {
    // Array to keep track of all deployed PerpetualsTradingContracts
    PerpetualsTradingContract[] public deployedContracts;

    // Event to log the creation of a new PerpetualsTradingContract
    event ContractCreated(address indexed contractAddress);

    // Function to create a new PerpetualsTradingContract
    function createPerpetualsTradingContract(address baseTokenAddress, address quoteTokenAddress) public {
        PerpetualsTradingContract newContract = new PerpetualsTradingContract(baseTokenAddress, quoteTokenAddress);
        deployedContracts.push(newContract);
        emit ContractCreated(address(newContract));
    }

    // Function to get the addresses of all deployed contracts
    function getDeployedContracts() public view returns (PerpetualsTradingContract[] memory) {
        return deployedContracts;
    }
}
