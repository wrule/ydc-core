// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Chainlink, ChainlinkClient } from "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import { ConfirmedOwner } from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import { LinkTokenInterface } from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract Test_Chainlink is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;

  uint256 public volume;
  bytes32 private jobId;
  uint256 private fee;

  event RequestVolume(bytes32 indexed requestId, uint256 volume);

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

    req._add(
        "get",
        "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=ETH&tsyms=USD"
    );

    req._add("path", "RAW,ETH,USD,VOLUME24HOUR"); // Chainlink nodes 1.0.0 and later support this format

    int256 timesAmount = 10 ** 18;
    req._addInt("times", timesAmount);

    return _sendChainlinkRequest(req, fee);
  }

  function fulfill(
    bytes32 _requestId,
    uint256 _volume
  ) public recordChainlinkFulfillment(_requestId) {
    emit RequestVolume(_requestId, _volume);
    volume = _volume;
  }

  function withdrawLink() public onlyOwner {
    LinkTokenInterface link = LinkTokenInterface(_chainlinkTokenAddress());
    require(
      link.transfer(msg.sender, link.balanceOf(address(this))),
      "Unable to transfer"
    );
  }
}
