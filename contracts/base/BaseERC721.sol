// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage, ERC721 } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Base, Ownable } from "./Base.sol";

contract BaseERC721 is Base, ERC721, ERC721Enumerable, ERC721URIStorage {
  using Strings for uint256;

  uint256 private _nextTokenId;
  string public baseURI;

  constructor(string memory name_, string memory symbol_)
    Base()
    ERC721(name_, symbol_)
  { }

  function safeMint(address to) internal returns (uint256) {
    uint256 tokenId = ++_nextTokenId;
    _safeMint(to, tokenId);
    return tokenId;
  }

  function getTokensOfOwner(address owner) public view returns (uint256[] memory) {
    uint256 tokenCount = balanceOf(owner);
    uint256[] memory tokens = new uint256[](tokenCount);

    for(uint256 i = 0; i < tokenCount; i++) {
      tokens[i] = tokenOfOwnerByIndex(owner, i);
    }
    return tokens;
  }

  function getTokensAndURIsOfOwner(address owner) public view returns (uint256[] memory tokenIds, string[] memory uris) {
    uint256 tokenCount = balanceOf(owner);
    tokenIds = new uint256[](tokenCount);
    uris = new string[](tokenCount);

    for(uint256 i = 0; i < tokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(owner, i);
      uris[i] = tokenURI(tokenIds[i]);
    }
    return (tokenIds, uris);
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  function setBaseURI(string memory newBaseURI) public onlyOwner {
    baseURI = newBaseURI;
  }

  function _update(address to, uint256 tokenId, address auth)
    internal
    override(ERC721, ERC721Enumerable)
    returns (address)
  {
    return super._update(to, tokenId, auth);
  }

  function _increaseBalance(address account, uint128 value)
    internal
    override(ERC721, ERC721Enumerable)
  {
    super._increaseBalance(account, value);
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    _requireOwned(tokenId);
    return bytes(baseURI).length > 0 ? string.concat(
      baseURI,
      "?id=",
      tokenId.toString()
    ) : "";
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable, ERC721URIStorage)
    returns (bool)
  {
    return super.supportsInterface(interfaceId);
  }
}
