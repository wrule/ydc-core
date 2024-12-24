// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Post {
  address sender;
  string content;
  uint64 likeCount;
  uint64 unlikeCount;
  uint256 createdAt;
  bool visible;
  uint256 prev;
  uint256 next;
  uint256 commentFor;
}

struct ST_YDC_Post_View {
  address sender;
  string content;
  uint64 likeCount;
  uint64 unlikeCount;
  uint256 createdAt;
  bool visible;
}

contract YDC_Post is BaseERC721 {
  constructor() BaseERC721("YiDeng College Post", "YDCPost") { }

  mapping(uint256 => ST_YDC_Post) public mapPost;
  mapping(uint256 => uint256) public mapCommentFor;

  function post(uint256 commentFor, string memory content) public returns (uint256) {
    uint256 tokenId = safeMint(_msgSender());
    mapPost[tokenId] = ST_YDC_Post({
      sender: _msgSender(),
      content: content,
      likeCount: 0,
      unlikeCount: 0,
      createdAt: block.timestamp,
      visible: true
    });
    return tokenId;
  }

  function like(uint256 tokenId) public {
    ST_YDC_Post storage post = mapPost[tokenId];
    require(post.visible, "YDC_Post: post is not visible");
    post.likeCount += 1;
  }

  function unlike(uint256 tokenId) public {
    ST_YDC_Post storage post = mapPost[tokenId];
    require(post.visible, "YDC_Post: post is not visible");
    post.unlikeCount += 1;
  }

  function flow() public view {

  }
}
