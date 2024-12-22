// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { YDC_Router } from "../YDC_Router.sol";

contract BaseUseRouter {
  constructor() { }

  YDC_Router router = YDC_Router(0x3c93db9F0F46F3b0FA159D445920DA563D1d5897);
}
