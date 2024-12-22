// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { ERC20Votes, ERC20 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import { Base } from "./base/Base.sol";

contract YDC_Token is ERC20, Base {
  constructor() Base() ERC20("YiDeng College Token", "YDC") { }

  function mintFor(address user, uint256 amount) public onlyOwner {
    _mint(user, amount);
  }

  function decimals() public view virtual override returns (uint8) {
    return 0;
  }
}
