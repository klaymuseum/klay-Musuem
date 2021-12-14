 pragma solidity ^0.5.6;

import "./klaytn-contracts/token/KIP17/KIP17Full.sol"; 
import "./klaytn-contracts/ownership/Ownable.sol";
import "./klaytn-contracts/token/KIP17/KIP17Pausable.sol";
import "./klaytn-contracts/utils/Strings.sol";
import "hardhat/console.sol";
import "./klaytn-contracts/token/KIP17/KIP17Burnable.sol";
contract KlayMusuem is KIP17Full,KIP17Pausable,KIP17Burnable, Ownable{
        constructor (string memory name, string memory symbol) public KIP17Full(name, symbol) {
    }
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    uint256 public cost = 50;
    uint256 public whiteListCost = 45;
    uint256 public pebMultiply =1000000000000000000;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 10;
    uint256 public maxWhitelistMintLimit = 5;
    bool public onlyWhitelisted = true;
    bool public mintPaused = true;
    address[] public whitelistedAddresses;

      // public
  function userMint(uint256 _mintAmount) public payable {
    uint256 supply = totalSupply();
    require(!paused(), "the contract is paused");
    require(mintPaused == false, "the contract is paused");
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply,"max NFT limit exceeded");

    if(onlyWhitelisted == false){
      require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
      require(msg.value == cost * pebMultiply * _mintAmount); 
      for (uint256 i = 1; i <= _mintAmount; i++) {
        _mint(msg.sender, supply + i);
      }
    } else{
      require(isWhitelisted(msg.sender), "user is not whitelisted");
      require(balanceOf(msg.sender) + _mintAmount <= maxWhitelistMintLimit);
      require(msg.value == whiteListCost * pebMultiply * _mintAmount); 
      for (uint256 i = 1; i <= _mintAmount; i++) {
        _mint(msg.sender, supply + i); 
      }
    } 
  }


  function setMaxSupply(uint256 _supply) public onlyOwner{
    maxSupply = _supply;
  }
  function mintPause() public onlyOwner{
    mintPaused = true;
  }
  function mintUnPause() public onlyOwner{
    mintPaused = false;
  }

  function preMint(address _to, uint256 _mintAmount) public onlyOwner{
    uint256 supply = totalSupply();
    require(supply + _mintAmount <= maxSupply);
    for (uint256 i = 1; i <= _mintAmount; i++) {
      _mint(_to, supply + i); //KIP17Enumerable의 mint 호출
    }
  }

 function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  }
 function insertwhitelistUsers(address[] memory _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
 function insertwhitelistUser(address _users) public onlyOwner {
    whitelistedAddresses.push(_users);
  }
 function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }

//지갑 소유자의 토큰목록 리턴
  function walletOfOwner(address _owner) public view returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }
      //토큰 id로 주소가져옴 ->웹에서 정렬함
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

  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
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
