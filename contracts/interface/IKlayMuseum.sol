 pragma solidity ^0.5.6;


interface IKlayMuseum {
    function cost() external view returns(uint256);
    function walletOfOwner(address _owner) external view returns (uint256[] memory);
    function balanceOf(address owner) external view returns (uint256);
}