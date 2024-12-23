// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Certificate_URI {
  uint256 tokenId;
  uint64 courseId;
  string uri;
}

contract YDC_Certificate is BaseERC721 {
  constructor() BaseERC721("YiDeng College Certificate", "YDCCertificate") { }

  mapping(uint256 => uint64) public mapCourseId;

  function claim(uint256 tokenId) public {

  }

  function getMyCertificates() public view returns (ST_YDC_Certificate_URI[] memory) {
    (uint256[] memory tokenIds, string[] memory uris) = getTokensAndURIsOfOwner(_msgSender());
    ST_YDC_Certificate_URI[] memory certificates = new ST_YDC_Certificate_URI[](tokenIds.length);
    for(uint256 i = 0; i < tokenIds.length; ++i) {
      certificates[i] = ST_YDC_Certificate_URI({
        tokenId: tokenIds[i],
        courseId: mapCourseId[tokenIds[i]],
        uri: uris[i]
      });
    }
    return certificates;
  }
}
