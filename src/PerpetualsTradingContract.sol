// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * @title PerpetualsTradingContract
 * @dev This contract handles the trading logic for a perpetuals DEX.
 * It includes order management, trade execution, and position tracking.
 */

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract PerpetualsTradingContract {
    // Struct to represent an order
    struct Order {
        address trader;
        uint256 amount;
        uint256 price;
        bool isBuy; // true for buy, false for sell
        bool isLong; // true for long, false for short
    }

    // State variables
    IERC20 public baseToken; // The token being traded
    IERC20 public quoteToken; // The token used for pricing
    Order[] public orderBook;
    
    // Events
    event OrderPlaced(uint256 indexed orderId, address indexed trader, uint256 amount, uint256 price, bool isBuy, bool isLong);
    event TradeExecuted(uint256 indexed buyOrderId, uint256 indexed sellOrderId, uint256 executedAmount);

    // Constructor
    constructor(address _baseTokenAddress, address _quoteTokenAddress) {
        baseToken = IERC20(_baseTokenAddress);
        quoteToken = IERC20(_quoteTokenAddress);
    }

    // Function to place an order
    function placeOrder(uint256 amount, uint256 price, bool isBuy, bool isLong) external {
        Order memory newOrder = Order({
            trader: msg.sender,
            amount: amount,
            price: price,
            isBuy: isBuy,
            isLong: isLong
        });

        orderBook.push(newOrder);
        emit OrderPlaced(orderBook.length - 1, msg.sender, amount, price, isBuy, isLong);
    }

    // Function to execute a trade
    function executeTrade(uint256 buyOrderId, uint256 sellOrderId) external {
        Order storage buyOrder = orderBook[buyOrderId];
        Order storage sellOrder = orderBook[sellOrderId];

        require(buyOrder.isBuy && !sellOrder.isBuy, "Invalid order types");
        require(buyOrder.price >= sellOrder.price, "Price mismatch");
        require(buyOrder.isLong != sellOrder.isLong, "Position direction must differ");

        uint256 executedAmount = min(buyOrder.amount, sellOrder.amount);

        // Transfer tokens between traders
        if (buyOrder.isLong) {
            require(baseToken.transferFrom(buyOrder.trader, sellOrder.trader, executedAmount), "Base token transfer failed");
        } else {
            require(quoteToken.transferFrom(buyOrder.trader, sellOrder.trader, executedAmount * buyOrder.price), "Quote token transfer failed");
        }

        // Update order amounts
        buyOrder.amount -= executedAmount;
        sellOrder.amount -= executedAmount;

        emit TradeExecuted(buyOrderId, sellOrderId, executedAmount);
    }

    // Utility function to find minimum of two values
    function min(uint256 a, uint256 b) private pure returns (uint256) {
        return a < b ? a : b;
    }
}
