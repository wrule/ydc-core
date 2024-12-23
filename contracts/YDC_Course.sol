// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Course {
  uint64 courseId;
  uint64 courseTypeId;
  string name;
  string summary;
}

contract YDC_Course is BaseERC721 {
  constructor() BaseERC721("YiDeng College Course", "YDCCourse") { }

  mapping(uint256 => ST_YDC_Course) mapCourseInfo;

  function deliver(
    address to,
    uint64 courseId,
    uint64 courseTypeId,
    string memory name,
    string memory summary
  ) public onlyOwner returns (uint256) {
    uint256 tokenId = safeMint(to);
    mapCourseInfo[tokenId] = ST_YDC_Course({
      courseId: courseId,
      courseTypeId: courseTypeId,
      name: name,
      summary: summary
    });
    return tokenId;
  }
}
