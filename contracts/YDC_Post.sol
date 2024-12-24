// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Post {
  address sender;
  string content;
  uint64 likeCount;
  uint64 unlikeCount;
  uint256 createdAt;
  uint256 prev;
  uint256 next;
  uint256 commentHead;
  uint256 commentTail;
}

contract YDC_Post is BaseERC721 {
  constructor() BaseERC721("YiDeng College Post", "YDCPost") { }

  mapping(uint256 => ST_YDC_Post) public mapPost;
  mapping(uint256 => uint256) public mapCommentFor;

  uint256 internal currentPostId = 0;

  function post(string memory content, uint256 commentFor) public returns (uint256) {
    uint256 tokenId = safeMint(_msgSender());

    if (commentFor == 0) {
      if (currentPostId != 0) {
        mapPost[currentPostId].next = tokenId;
      }
      mapPost[tokenId] = ST_YDC_Post({
        sender: _msgSender(),
        content: content,
        likeCount: 0,
        unlikeCount: 0,
        createdAt: block.timestamp,
        prev: currentPostId,
        next: 0,
        commentHead: 0,
        commentTail: 0
      });
      currentPostId = tokenId;
    } else {

    }

    return tokenId;
  }

  function flow() public view {

  }
}
