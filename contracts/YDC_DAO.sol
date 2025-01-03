// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Token } from "./YDC_Token.sol";

struct YDC_DAO_Proposal {
  uint64 id;
  address proposer;
  address target;
  bytes action;
  string prototype;
  string summary;
  uint256 yesVotes;
  uint256 noVotes;
  uint256 createdAt;
  uint256 deadlineAt;
}

contract YDC_DAO is BaseUseRouter {
  constructor() BaseUseRouter() { }

  uint64 public currentProposalId = 0;
  mapping(uint64 => YDC_DAO_Proposal) mapProposal;
  mapping(uint64 => mapping(address => bool)) mapVoted;
  mapping(uint64 => bool) mapExecuted;

  error Error_NoProposeRights(address sender);

  function initiateProposal(
    address target,
    bytes memory action,
    string memory prototype,
    string memory summary,
    uint256 deadlineAt
  ) public returns (uint64) {
    uint256 votes = YDC_Token(router.get("YDC_Token")).balanceOf(msg.sender);
    if (votes == 0) {
      revert Error_NoProposeRights(msg.sender);
    }
    currentProposalId++;
    mapProposal[currentProposalId] = YDC_DAO_Proposal({
      id: currentProposalId,
      proposer: msg.sender,
      target: target,
      action: action,
      prototype: prototype,
      summary: summary,
      yesVotes: 0,
      noVotes: 0,
      createdAt: block.timestamp,
      deadlineAt: deadlineAt
    });
    return currentProposalId;
  }

  error Error_ProposalNotExist(address sender, uint64 proposalId);
  error Error_HasEnded(address sender, uint64 proposalId, uint256 deadlineAt);
  error Error_NoEnded(address sender, uint64 proposalId, uint256 deadlineAt);
  error Error_NoVotingRights(address sender, uint64 proposalId);
  error Error_RepeatVoting(address sender, uint64 proposalId);
  error Error_Executed(address sender, uint64 proposalId);
  error Error_NotApproved(address sender, uint64 proposalId);
  error Error_ExecutionFailed(address sender, uint64 proposalId);
  event Event_Vote(address indexed sender, uint64 proposalId, bool yes, uint256 votes);

  function vote(uint64 proposalId, bool yes) public {
    if (mapProposal[proposalId].id == 0) {
      revert Error_ProposalNotExist(msg.sender, proposalId);
    }
    if (block.timestamp > mapProposal[proposalId].deadlineAt) {
      revert Error_HasEnded(msg.sender, proposalId, mapProposal[proposalId].deadlineAt);
    }
    uint256 votes = YDC_Token(router.get("YDC_Token")).balanceOf(msg.sender);
    if (votes == 0) {
      revert Error_NoVotingRights(msg.sender, proposalId);
    }
    if (mapVoted[proposalId][msg.sender]) {
      revert Error_RepeatVoting(msg.sender, proposalId);
    }
    if (yes) {
      mapProposal[proposalId].yesVotes += votes;
    } else {
      mapProposal[proposalId].noVotes += votes;
    }
    mapVoted[proposalId][msg.sender] = true;
    emit Event_Vote(msg.sender, proposalId, yes, votes);
  }

  function execute(uint64 proposalId) public {
    if (mapProposal[proposalId].id == 0) {
      revert Error_ProposalNotExist(msg.sender, proposalId);
    }
    if (block.timestamp <= mapProposal[proposalId].deadlineAt) {
      revert Error_NoEnded(msg.sender, proposalId, mapProposal[proposalId].deadlineAt);
    }
    if (mapExecuted[proposalId]) {
      revert Error_Executed(msg.sender, proposalId);
    }
    if (mapProposal[proposalId].yesVotes <= mapProposal[proposalId].noVotes) {
      revert Error_NotApproved(msg.sender, proposalId);
    }
    (bool success, ) = mapProposal[proposalId].target.call(mapProposal[proposalId].action);
    if (!success) {
      revert Error_ExecutionFailed(msg.sender, proposalId);
    }
    mapExecuted[proposalId] = true;
  }

  function flow(uint64 head) public view returns (YDC_DAO_Proposal[] memory) {
    uint64 size = head < 10 ? head : 10;
    YDC_DAO_Proposal[] memory result = new YDC_DAO_Proposal[](size);
    for (uint64 i = 0; i < size; ++i) {
      result[size - 1 - i] = mapProposal[head - i];
    }
    return result;
  }

  function acceptOwnershipForMe(address target) public {
    Ownable2Step(target).acceptOwnership();
  }
}
