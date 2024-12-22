// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Base } from "./base/Base.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Token } from "./YDC_Token.sol";

contract YDC_AnchoredSwap is Base, BaseUseRouter {
  constructor() Base() BaseUseRouter() { }

  uint256 public constant EQ_1YDC_ETH_AMOUNT = 0.0000001 ether;

  YDC_Token ydcToken = YDC_Token(router.get("YDC_Token"));

  function ETH2YDC() public payable {
    uint256 shares = msg.value / EQ_1YDC_ETH_AMOUNT;
    ydcToken.mintFor(_msgSender(), shares);
    uint256 change = msg.value - shares * EQ_1YDC_ETH_AMOUNT;
    if (change > 0) {
      payable(_msgSender()).transfer(change);
    }
  }

  function YDC2ETH(uint256 ydcAmount) public {
    ydcToken.transferFrom(_msgSender(), address(this), ydcAmount);
    payable(_msgSender()).transfer(ydcAmount * EQ_1YDC_ETH_AMOUNT);
  }
}
