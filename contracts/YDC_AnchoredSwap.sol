// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Base } from "./base/Base.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Token } from "./YDC_Token.sol";

contract YDC_AnchoredSwap is Base, BaseUseRouter {
  constructor() Base() BaseUseRouter() { }

  uint256 public constant EQ_1YDC_ETH_AMOUNT = 0.0000001 ether;

  error Error_InsufficientETH(address sender, uint256 ethAmount);
  error Error_InsufficientYDC(address sender, uint256 ydcAmount);

  event Event_ETH2YDC(address indexed sender, uint256 ethAmount, uint256 ydcAmount);
  event Event_YDC2ETH(address indexed sender, uint256 ydcAmount, uint256 ethAmount);

  function ETH2YDC() public payable {
    uint256 ydcAmount = msg.value / EQ_1YDC_ETH_AMOUNT;
    if (ydcAmount < 1) {
      revert Error_InsufficientETH(_msgSender(), msg.value);
    }
    uint256 ethAmount = ydcAmount * EQ_1YDC_ETH_AMOUNT;
    YDC_Token(router.get("YDC_Token")).mintFor(_msgSender(), ydcAmount);
    uint256 change = msg.value - ethAmount;
    if (change > 0) {
      payable(_msgSender()).transfer(change);
    }
    emit Event_ETH2YDC(_msgSender(), ethAmount, ydcAmount);
  }

  function YDC2ETH(uint256 ydcAmount) public {
    if (ydcAmount < 1) {
      revert Error_InsufficientYDC(_msgSender(), ydcAmount);
    }
    YDC_Token(router.get("YDC_Token")).transferFrom(_msgSender(), address(this), ydcAmount);
    uint256 ethAmount = ydcAmount * EQ_1YDC_ETH_AMOUNT;
    payable(_msgSender()).transfer(ethAmount);
    emit Event_YDC2ETH(_msgSender(), ydcAmount, ethAmount);
  }
}
