// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * @title FundingRateContract
 * @dev This contract manages the funding rate for a perpetuals trading platform.
 */

contract FundingRateContract {
    // State variables
    uint256 public fundingRate; // Current funding rate
    uint256 public lastUpdateTime; // Timestamp of the last funding rate update

    // Constants
    uint256 public constant FUNDING_INTERVAL = 8 hours; // Interval at which the funding rate is updated

    // Events
    event FundingRateUpdated(uint256 indexed newFundingRate, uint256 timestamp);

    // Constructor
    constructor() {
        lastUpdateTime = block.timestamp;
    }

    // Function to update the funding rate
    function updateFundingRate(uint256 marketPrice, uint256 spotPrice) external {
        require(block.timestamp >= lastUpdateTime + FUNDING_INTERVAL, "Funding rate update interval not reached");

        // Example calculation: (marketPrice - spotPrice) / spotPrice
        // This is a simplified version. In practice, this could involve more complex calculations and safety checks.
        uint256 newFundingRate = (marketPrice > spotPrice) ? ((marketPrice - spotPrice) * 1e18 / spotPrice) : ((spotPrice - marketPrice) * 1e18 / spotPrice);
        fundingRate = newFundingRate;

        lastUpdateTime = block.timestamp;
        emit FundingRateUpdated(newFundingRate, block.timestamp);
    }

    // Function to apply funding to a trader's position
    // This is a placeholder function. The actual implementation would involve interacting with the trader's position, adjusting their P&L based on the funding rate, position size, and direction.
    function applyFunding(address trader, uint256 positionSize, bool isLong) external {
        // Placeholder logic for applying funding payment or charge
        uint256 fundingPayment = positionSize * fundingRate / 1e18;
        // Apply funding payment or charge to the trader's position
    }

    // Additional functions and safety checks can be added here.
}
