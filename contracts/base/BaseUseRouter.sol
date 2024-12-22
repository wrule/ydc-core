// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { YDC_Router } from "../YDC_Router.sol";

contract BaseUseRouter {
  constructor() { }

  YDC_Router router = YDC_Router(0x49155F5A274fC463E6ef9cefC122b51cd899303E);
}
