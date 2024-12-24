// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Chainlink, ChainlinkClient } from "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import { ConfirmedOwner } from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import { LinkTokenInterface } from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract Test_Chainlink is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;

  uint256 public num;
  bytes32 private jobId;
  uint256 private fee;

  event RequestVolume(bytes32 indexed requestId, uint256 num);

  constructor() ConfirmedOwner(msg.sender) {
    _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
    _setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
    jobId = "ca98366cc7314957b8c012c72f05aeeb";
    fee = (1 * LINK_DIVISIBILITY) / 10;
  }

  function requestVolumeData() public returns (bytes32 requestId) {
    Chainlink.Request memory req = _buildChainlinkRequest(
      jobId,
      address(this),
      this.fulfill.selector
    );
    req._add("get", "https://pub-957003e8a7b049aaa00dfe01e18fd1e0.r2.dev/link.json");
    req._add("path", "num");
    return _sendChainlinkRequest(req, fee);
  }

  function fulfill(
    bytes32 _requestId,
    uint256 _num
  ) public recordChainlinkFulfillment(_requestId) {
    emit RequestVolume(_requestId, _num);
    num = _num;
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(_chainlinkTokenAddress());
    require(
      link.transfer(msg.sender, link.balanceOf(address(this))),
      "Unable to transfer"
    );
  }
}
