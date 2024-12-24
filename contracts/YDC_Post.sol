// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { BaseERC721 } from "./base/BaseERC721.sol";

contract YDC_Post is BaseERC721 {
  constructor() BaseERC721("YiDeng College Post", "YDCPost") { }
}
