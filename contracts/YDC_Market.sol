// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";
import { BaseUseRouter } from "./base/BaseUseRouter.sol";
import { YDC_Token } from "./YDC_Token.sol";
import { YDC_Course } from "./YDC_Course.sol";

struct ST_YDC_Item {
  address seller;
  uint256 price;
  uint64 courseId;
  uint64 courseTypeId;
  string name;
  string summary;
}

struct ST_YDC_Item_URI {
  address seller;
  uint256 price;
  uint64 courseId;
  uint64 courseTypeId;
  string name;
  string summary;
  string uri;
}

contract YDC_Market is BaseERC721, BaseUseRouter {
  constructor() BaseERC721("YiDeng College Item", "YDCItem") BaseUseRouter() { }

  mapping(uint256 => ST_YDC_Item) public mapItem;
  mapping(uint64 => uint256) public mapTokenId;

  error Error_DuplicateCourseId(address sender, uint64 courseId);
  event Event_ListCourse(address indexed sender, uint64 courseId);
  function listCourse(
    uint64 courseId,
    uint64 courseTypeId,
    string memory name,
    string memory summary,
    uint256 price
  ) public onlyOwner returns (uint256) {
    if (mapTokenId[courseId] != 0) {
      revert Error_DuplicateCourseId(_msgSender(), courseId);
    }
    uint256 tokenId = safeMint(address(this));
    mapItem[tokenId] = ST_YDC_Item({
      seller: _msgSender(),
      price: price,
      courseId: courseId,
      courseTypeId: courseTypeId,
      name: name,
      summary: summary
    });
    mapTokenId[courseId] = tokenId;
    emit Event_ListCourse(_msgSender(), courseId);
    return tokenId;
  }

  event Event_BuyCourse(address indexed sender, uint64 courseId);
  function buyCourse(uint64 courseId) public {
    uint256 tokenId = mapTokenId[courseId];
    _requireOwned(tokenId);
    ST_YDC_Item memory item = mapItem[tokenId];
    YDC_Token ydcToken = YDC_Token(router.get("YDC_Token"));
    YDC_Course ydcCourse = YDC_Course(router.get("YDC_Course"));
    ydcToken.transferFrom(_msgSender(), item.seller, item.price);
    ydcCourse.deliver(_msgSender(), item.courseId, item.courseTypeId, item.name, item.summary);
    emit Event_BuyCourse(_msgSender(), courseId);
  }
}
