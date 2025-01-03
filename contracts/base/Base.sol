// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Ownable2Step, Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract Base is Ownable2Step {
  constructor() Ownable(_msgSender()) { }

  function acceptOwnershipForMe(address target) public {
    Ownable2Step(target).acceptOwnership();
  }
}
