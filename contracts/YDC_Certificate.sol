// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

contract YDC_Certificate is BaseERC721 {
  constructor() BaseERC721("YiDeng College Certificate", "YDCCertificate") { }

  mapping(uint256 => uint64) public mapCourseId;

  function reward(
    address to,
    uint64 courseId
  ) public returns (uint256) {
    uint256 tokenId = safeMint(to);
    mapCourseId[tokenId] = courseId;
    return tokenId;
  }
}
