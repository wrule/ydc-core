// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract Test_Chainlink is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;

  uint256 public num;

  bytes32 private jobId;
  uint256 private fee;

  constructor() ConfirmedOwner(msg.sender) {
    _setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
    _setChainlinkOracle(0x6090149792dAAeE9D1D568c9f9a6F6B46AA29eFD);
    jobId = "7d80a6386ef543a3abb52817f6707e3b";  // HTTP Get > uint256 job
    fee = (1 * LINK_DIVISIBILITY) / 10; // 0.1 LINK
  }

  function updateNum() public returns (bytes32 requestId) {
    Chainlink.Request memory req = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
    req._add("get", "https://pub-957003e8a7b049aaa00dfe01e18fd1e0.r2.dev/link.json");
    req._add("path", "num");
    return _sendChainlinkRequest(req, fee);
  }

  function fulfill(bytes32 _requestId, uint256 _num) public recordChainlinkFulfillment(_requestId) {
    num = _num;
  }
}
