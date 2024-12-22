// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { YDC_Router } from "../YDC_Router.sol";

contract BaseUseRouter {
  constructor() { }

  YDC_Router router = YDC_Router(0x4CC8AB5b96a8Dd746ac9b3B8A5C071f7C7600Dd3);
}
