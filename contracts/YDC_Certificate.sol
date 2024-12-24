// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Certificate {
  uint64 courseId;
  uint256 courseTokenId;
}

struct ST_YDC_Certificate_URI {
  uint256 tokenId;
  uint64 courseId;
  uint256 courseTokenId;
  string uri;
}

contract YDC_Certificate is BaseERC721 {
  constructor() BaseERC721("YiDeng College Certificate", "YDCCertificate") { }

  mapping(uint256 => ST_YDC_Certificate) public mapCertificate;

  function reward(address to, uint64 courseId, uint256 courseTokenId) public onlyOwner returns (uint256) {
    uint256 tokenId = safeMint(to);
    mapCertificate[tokenId] = ST_YDC_Certificate({
      courseId: courseId,
      courseTokenId: courseTokenId
    });
    return tokenId;
  }

  function getMyCertificates() public view returns (ST_YDC_Certificate_URI[] memory) {
    (uint256[] memory tokenIds, string[] memory uris) = getTokensAndURIsOfOwner(_msgSender());
    ST_YDC_Certificate_URI[] memory certificates = new ST_YDC_Certificate_URI[](tokenIds.length);
    for(uint256 i = 0; i < tokenIds.length; ++i) {
      certificates[i] = ST_YDC_Certificate_URI({
        tokenId: tokenIds[i],
        courseId: mapCertificate[tokenIds[i]].courseId,
        courseTokenId: mapCertificate[tokenIds[i]].courseTokenId,
        uri: uris[i]
      });
    }
    return certificates;
  }
}
