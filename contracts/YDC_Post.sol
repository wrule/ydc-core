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

  uint256 public currentPostId = 0;

  function post(string memory content, uint256 commentFor) public returns (uint256) {
    uint256 tokenId = safeMint(_msgSender());
    mapPost[tokenId] = ST_YDC_Post({
      sender: _msgSender(),
      content: content,
      likeCount: 0,
      unlikeCount: 0,
      createdAt: block.timestamp,
      prev: 0,
      next: 0,
      commentHead: 0,
      commentTail: 0
    });

    if (commentFor == 0) {
      if (currentPostId != 0) {
        mapPost[currentPostId].next = tokenId;
      }
      mapPost[tokenId].prev = currentPostId;
      currentPostId = tokenId;
    } else {
      _requireOwned(commentFor);
      if (mapPost[commentFor].commentHead == 0) {
        mapPost[commentFor].commentHead = tokenId;
        mapPost[commentFor].commentTail = tokenId;
      } else {
        mapPost[mapPost[commentFor].commentTail].next = tokenId;
        mapPost[tokenId].prev = mapPost[commentFor].commentTail;
        mapPost[commentFor].commentTail = tokenId;
      }
    }

    return tokenId;
  }

  function flow(uint256 postId, bool forward) public view returns (ST_YDC_Post[] memory) {
    if (postId != 0) {
      _requireOwned(postId);
    }

    uint256 currentId = postId;

    uint8 count = 0;
    for (;count < 10 && currentId != 0; ++count) {
      if (forward) {
        currentId = mapPost[currentId].next;
      } else {
        currentId = mapPost[currentId].prev;
      }
    }

    currentId = postId;

    ST_YDC_Post[] memory posts = new ST_YDC_Post[](count);
    for (uint8 i = 0; i < count; ++i) {
      posts[i] = mapPost[currentId];
      if (forward) {
        currentId = mapPost[currentId].next;
      } else {
        currentId = mapPost[currentId].prev;
      }
    }

    return posts;
  }
}
