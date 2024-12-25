// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

struct YDC_DAO_Proposal {
  uint64 id;
  address target;
  bytes action;
  string prototype;
  string summary;
  uint256 yesVotes;
  uint256 noVotes;
  uint256 deadline;
  uint64 prevId;
}

contract YDC_DAO is BaseUseRouter {
  constructor() BaseUseRouter() { }

  function acceptOwnershipForMe(address target) public {
    Ownable2Step(target).acceptOwnership();
  }
}
