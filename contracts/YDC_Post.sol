// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

struct ST_YDC_Post {
  uint256 postId;
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

enum EM_LIKE_STATE { NONE, LIKE, UNLIKE }

contract YDC_Post is BaseERC721 {
  constructor() BaseERC721("YiDeng College Post", "YDCPost") { }

  mapping(uint256 => ST_YDC_Post) public mapPost;
  mapping(address => mapping(uint256 => EM_LIKE_STATE)) mapLike;

  uint256 public currentPostId = 0;

  event Event_Post(address indexed sender, uint256 postId, uint256 commentFor);

  function post(string memory content, uint256 commentFor) public returns (uint256) {
    uint256 tokenId = safeMint(_msgSender());
    mapPost[tokenId] = ST_YDC_Post({
      postId: tokenId,
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

    emit Event_Post(_msgSender(), tokenId, commentFor);

    return tokenId;
  }

  function flow(uint256 postId, bool reverse) public view returns (ST_YDC_Post[] memory) {
    _requireOwned(postId);
    uint256 currentId = postId;
    uint8 count = 0;
    for (;count < 10 && currentId != 0; ++count) {
      currentId = reverse ? mapPost[currentId].prev : mapPost[currentId].next;
    }
    currentId = postId;
    ST_YDC_Post[] memory posts = new ST_YDC_Post[](count);
    for (uint8 i = 0; i < count; ++i) {
      posts[i] = mapPost[currentId];
      currentId = reverse ? mapPost[currentId].prev : mapPost[currentId].next;
    }
    return posts;
  }

  error ERROR_RepeatOperation(address sender, uint256 postId, EM_LIKE_STATE state);
  event Event_Like(address indexed sender, uint256 postId, EM_LIKE_STATE state);

  function like(uint256 postId) public {
    _requireOwned(postId);
    if (mapLike[_msgSender()][postId] == EM_LIKE_STATE.LIKE) {
      revert ERROR_RepeatOperation(_msgSender(), postId, EM_LIKE_STATE.LIKE);
    }
    if (mapLike[_msgSender()][postId] == EM_LIKE_STATE.UNLIKE) {
      mapPost[postId].unlikeCount--;
    }
    mapLike[_msgSender()][postId] = EM_LIKE_STATE.LIKE;
    mapPost[postId].likeCount++;
    emit Event_Like(_msgSender(), postId, EM_LIKE_STATE.LIKE);
  }

  function unlike(uint256 postId) public {
    _requireOwned(postId);
    if (mapLike[_msgSender()][postId] == EM_LIKE_STATE.UNLIKE) {
      revert ERROR_RepeatOperation(_msgSender(), postId, EM_LIKE_STATE.UNLIKE);
    }
    if (mapLike[_msgSender()][postId] == EM_LIKE_STATE.LIKE) {
      mapPost[postId].likeCount--;
    }
    mapLike[_msgSender()][postId] = EM_LIKE_STATE.UNLIKE;
    mapPost[postId].unlikeCount++;
    emit Event_Like(_msgSender(), postId, EM_LIKE_STATE.UNLIKE);
  }

  function remove(uint256 postId) public onlyOwner {
    _requireOwned(postId);
    uint256 prevPostId = mapPost[postId].prev;
    uint256 nextPostId = mapPost[postId].next;
    if (prevPostId == 0 && nextPostId == 0) {
      currentPostId = 0;
    } else if (prevPostId == 0 && nextPostId != 0) {
      mapPost[nextPostId].prev = 0;
    } else if (prevPostId != 0 && nextPostId == 0) {
      mapPost[prevPostId].next = 0;
      currentPostId = prevPostId;
    } else {
      mapPost[prevPostId].next = nextPostId;
      mapPost[nextPostId].prev = prevPostId;
    }
  }
}
