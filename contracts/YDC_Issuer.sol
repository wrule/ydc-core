// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Chainlink, ChainlinkClient } from "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import { ConfirmedOwner } from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import { LinkTokenInterface } from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Course } from "./YDC_Course.sol";

contract YDC_Issuer is ChainlinkClient, ConfirmedOwner, BaseUseRouter {
  using Chainlink for Chainlink.Request;

  uint256 public num;
  bytes32 private jobId;
  uint256 private fee;

  string web2ApiURL;
  function setWeb2ApiURL(string memory _web2ApiURL) public onlyOwner {
    web2ApiURL = _web2ApiURL;
  }

  mapping(address => mapping(uint256 => uint256)) public mapCourseUpdateTime;
  mapping(address => mapping(uint256 => uint256)) public mapCourseCertificate;

  event RequestVolume(bytes32 indexed requestId, uint256 num);

  constructor() ConfirmedOwner(msg.sender) {
    _setChainlinkToken(router.get("Link_Token"));
    _setChainlinkOracle(router.get("Link_Oracle"));
    jobId = "ca98366cc7314957b8c012c72f05aeeb";
    fee = (1 * LINK_DIVISIBILITY) / 10;
  }

  error Error_CourseNotOwned(address sender, uint256 tokenId);
  error Error_AlreadyIssued(address sender, uint256 courseTokenId, uint256 certificateTokenId);
  error Error_TooFrequent(address sender, uint256 courseTokenId);

  function requestCertificate(uint256 courseTokenId) public returns (bytes32 requestId) {
    // 请求前置验证
    YDC_Course ydcCourse = YDC_Course(router.get("YDC_Course"));
    if (ydcCourse.ownerOf(courseTokenId) != msg.sender) {
      revert Error_CourseNotOwned(msg.sender, courseTokenId);
    }
    if (mapCourseCertificate[msg.sender][courseTokenId] != 0) {
      revert Error_AlreadyIssued(msg.sender, courseTokenId, mapCourseCertificate[msg.sender][courseTokenId]);
    }
    if (block.timestamp - mapCourseUpdateTime[msg.sender][courseTokenId] < 1 days) {
      revert Error_TooFrequent(msg.sender, courseTokenId);
    }

    // 构造预言机请求
    Chainlink.Request memory req = _buildChainlinkRequest(
      jobId,
      address(this),
      this.fulfill.selector
    );
    req._add("get", web2ApiURL);
    req._add("path", "data,progress");
    int256 timesAmount = 10 ** 0;
    req._addInt("times", timesAmount);
    bytes32 result = _sendChainlinkRequest(req, fee);

    // 更新请求时间
    mapCourseUpdateTime[msg.sender][courseTokenId] = block.timestamp;

    return result;
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
