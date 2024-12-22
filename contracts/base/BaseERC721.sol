// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { ERC721URIStorage, ERC721 } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Base, Ownable } from "./Base.sol";

contract BaseERC721 is ERC721URIStorage, Base {
  using Strings for uint256;

  uint256 private _nextTokenId;
  string private baseURI;

  constructor(string memory name_, string memory symbol_)
    Base()
    ERC721(name_, symbol_) { }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function setBaseURI(string memory newBaseURI) public onlyOwner {
    baseURI = newBaseURI;
  }

  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    _requireOwned(tokenId);
    return bytes(baseURI).length > 0 ?
      string.concat(baseURI, "?id=", tokenId.toString()) :
      "";
  }
}
