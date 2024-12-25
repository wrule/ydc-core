// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract DAO is BaseUseRouter {
  constructor() BaseUseRouter() { }

  function acceptOwnershipForMe(address target) public {
    Ownable2Step(target).acceptOwnership();
  }
}
