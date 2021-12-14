 pragma solidity ^0.5.6;

import "./klaytn-contracts-custom/token/KIP17/KIP17Full.sol";
import "./klaytn-contracts-custom/ownership/Ownable.sol";
import "./klaytn-contracts-custom/token/KIP17/KIP17Pausable.sol";
import "./klaytn-contracts-custom/utils/Strings.sol";
import "./interface/IKlayMuseum.sol";
import "hardhat/console.sol";

contract WelcomDrink is KIP17Full,KIP17Pausable, Ownable{

    IKlayMuseum public klayMuseum; 
    constructor (string memory name, string memory symbol, IKlayMuseum _klayMuseum) public KIP17Full(name, symbol) {
      klayMuseum = _klayMuseum;
    }
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 10;
    uint256[] public usedPass;

  function airdropMint(uint256 _mintAmount) public {
    uint256 supply = totalSupply();
    require(!paused(), "the contract is paused");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(supply + _mintAmount <= maxSupply,"max NFT limit exceeded");

    uint256[] memory tokens =  klayMuseum.walletOfOwner(msg.sender); 
    uint256  count = 0;
    for (uint256 i; i < tokens.length; i++) {
         address  ownAds = ownerOf(tokens[i]); //동일한 토큰번호 발행여부확인
         if(count == _mintAmount){
           return;
         }
         if(ownAds == address(0)) {//미발행이면 동일한 아이디로 민트
            _mint(msg.sender, tokens[i]); 
            count++;
         }
    }
  }

  function getMintableAmount() public view returns(uint256) {
    uint256[] memory tokens =  klayMuseum.walletOfOwner(msg.sender); 
    uint256  count = 0;
    for (uint256 i; i < tokens.length; i++) {
         address  ownAds = ownerOf(tokens[i]); 
         if(ownAds == address(0)) {
            count++;
         }
    }
    return count;
  }
  function setMaxSupply(uint256 _supply) public onlyOwner{
    maxSupply = _supply;
  }
  function walletOfOwner(address _owner) public view returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }
  function getHolderAddress(uint amount) public view returns(address[] memory){
      address[] memory holderAddress = new address[](amount);
      for (uint256 i = 1; i <= amount; i++) {
        holderAddress[i] = ownerOf(i);
      }
      return holderAddress;
  }
  function tokenURI(uint256 tokenId) public view returns (string memory){
    require(
      _exists(tokenId), 
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)): "";
  }

  function _baseURI() internal view returns (string memory) {
    return baseURI;
  }


  function setBaseURIs(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function getContractBalance() public view returns(uint) {
      return address(this).balance;
  }

  function withdraw() public payable onlyOwner {
      owner().transfer(address(this).balance);
  }




}
