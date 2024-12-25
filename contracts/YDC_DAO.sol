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
  uint256 createdAt;
  uint256 deadlineAt;
  uint64 prevId;
}

contract YDC_DAO is BaseUseRouter {
  constructor() BaseUseRouter() { }

  uint64 currentProposalId = 0;
  mapping(uint64 => YDC_DAO_Proposal) mapProposal;

  function initiateProposal(
    address target,
    bytes memory action,
    string memory prototype,
    string memory summary,
    uint256 deadlineAt
  ) public returns (uint64) {
    currentProposalId++;
    mapProposal[currentProposalId] = YDC_DAO_Proposal({
      id: currentProposalId,
      target: target,
      action: action,
      prototype: prototype,
      summary: summary,
      yesVotes: 0,
      noVotes: 0,
      createdAt: block.timestamp,
      deadlineAt: deadlineAt,
      prevId: currentProposalId - 1
    });
    return currentProposalId;
  }

  function acceptOwnershipForMe(address target) public {
    Ownable2Step(target).acceptOwnership();
  }
}
