// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Ownable2Step, Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract YDC_Router is Ownable2Step {
  constructor() Ownable(_msgSender()) { }

  mapping(string => address) private mapAddress;

  error Error_DoesNotExist(string name);
  error Error_InvalidAddress(string name, address newAddress);

  function get(string memory name) public view returns (address) {
    address result = mapAddress[name];
    if (result == address(0)) revert Error_DoesNotExist(name);
    return result;
  }

  function set(string memory name, address newAddress) public onlyOwner {
    if (newAddress == address(0)) revert Error_InvalidAddress(name, newAddress);
    mapAddress[name] = newAddress;
  }
}
