// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Base } from "./base/Base.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Token } from "./YDC_Token.sol";

contract YDC_AnchoredSwap is Base, BaseUseRouter {
  constructor() Base() BaseUseRouter() { }

  uint256 public constant EQ_YDC_AMOUNT = 1000;
  uint256 public constant EQ_ETH_AMOUNT = 0.0001 ether;

  YDC_Token ydcToken = YDC_Token(router.get("YDC_Token"));

  function ETH2YDC() public payable {

  }

  function YDC2ETH(uint256 ydcAmount) public {
    uint256 shares = ydcAmount / EQ_YDC_AMOUNT;
    ydcToken.transferFrom(_msgSender(), address(this), shares * EQ_YDC_AMOUNT);
    payable(_msgSender()).transfer(shares * EQ_ETH_AMOUNT);
  }
}
