// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address[] private s_founders;
    mapping(address founder => uint256 amountFounded) private s_addressToAmountFounded;
    AggregatorV3Interface private s_priceFeed;

    address private immutable I_OWNER;

    constructor(address priceFeed) {
        I_OWNER = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "did not send enougth ETH");
        s_founders.push(msg.sender);
        s_addressToAmountFounded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // Reset the mapping
        for (uint256 i = 0; i < s_founders.length; i++) {
            s_addressToAmountFounded[s_founders[i]] = 0;
        }

        // Reset the array
        s_founders = new address[](0);

        // Withdraw the fund to msg.sender
        // 1 - Transfer : if transfer fail => throw error and revert
        //payable(msg.sender).transfer(address(this).balance);
        // 2- send : if send fail :> return false
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "send failed");
        // 3- call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    function cheaperWithdraw() public onlyOwner {
        address[] memory founders = s_founders;
        for (uint256 i = 0; i < founders.length; i++) {
            s_addressToAmountFounded[founders[i]] = 0;
        }
        s_founders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if (msg.sender != I_OWNER) revert NotOwner();
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // Getter functions
    function getAddressToAmountFounded(address founder) external view returns (uint256) {
        return s_addressToAmountFounded[founder];
    }

    function getFounder(uint256 index) external view returns (address) {
        return s_founders[index];
    }

    function getOwner() external view returns (address) {
        return I_OWNER;
    }
}
