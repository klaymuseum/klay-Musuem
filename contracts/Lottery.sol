 pragma solidity ^0.5.6;
import "./klaytn-contracts/ownership/Ownable.sol";
import "./interface/IKlayMuseum.sol";
import "hardhat/console.sol";

 contract Lottery is Ownable{

    IKlayMuseum public klayMuseum; 

    bool public lotteryPaused = true;
    uint256 public nowLotteryId = 1;
    mapping(uint => address[])  public lotteryEnterAddressList; //내역번호 -> 참가자 주소 목록
    mapping(uint => uint256) public totalTicket;
    mapping(uint => uint16[]) public enterPassAmounts; //내역번호 -> 패스 보유수량 목록
    mapping(uint => address[]) public lotteryWinHistory; //내역번호 ->당첨자 주소 명단

    constructor (IKlayMuseum _klayMuseum) public{
      klayMuseum = _klayMuseum;
    }


  //추첨 참가
  function lotteryEnter() public{
    require(!lotteryPaused,"lottery paused");
    require(0 < klayMuseum.balanceOf(msg.sender),"require museum pass");
    require(!isSenderLotteryEnter());
    lotteryEnterAddressList[nowLotteryId].push(msg.sender);
  }
  //이미 추첨 참가여부확인
  function isSenderLotteryEnter() public view returns(bool){
    for(uint256 i = 1; i <= lotteryEnterAddressList[nowLotteryId].length; i++) {
        if(msg.sender == lotteryEnterAddressList[nowLotteryId][i-1]) { 
            return true;
        }
    }
    return false;
  }

  //추첨 허용 중지
  function lotteryPause() public onlyOwner {
    lotteryPaused = true;
  }
  //추첨 허용
  function lotteryUnPause() public onlyOwner {
    lotteryPaused = false;
  }
  function setTotalTicket(uint256 _amount) public onlyOwner {
    require(_amount > 0);
    totalTicket[nowLotteryId] = _amount;
  }
  function setEnterPassAmounts(uint16[] memory _passAmounts) public onlyOwner {
    require(_passAmounts.length > 0);
    enterPassAmounts[nowLotteryId] =_passAmounts;
  }
  function setNextLotteryId() public onlyOwner {
    nowLotteryId++;
  }

  function getLotteryWinnerList(uint256 _historyId) public view returns(address[] memory){
    return lotteryWinHistory[_historyId] ;
  }
  function getLotteryEnterAddressList(uint256 _historyId) public view returns(address[] memory){
    return lotteryEnterAddressList[_historyId] ;
  }
  function getEnterPassAmounts(uint256 _historyId) public view returns(uint16[] memory){
    return enterPassAmounts[_historyId] ;
  }
  function calTotalTicket() public onlyOwner {
    uint256  totalTickets;
    require(enterPassAmounts[nowLotteryId].length > 0);
    for (uint256 i; i < enterPassAmounts[nowLotteryId].length; i++) {
      totalTickets = totalTickets + enterPassAmounts[nowLotteryId][i];
    }
    totalTicket[nowLotteryId] = totalTickets;
  }

  //추첨
  function drawLotteryWinner() public onlyOwner {
    lotteryPaused = true;
    uint256  count = 0;
    uint256  randomNumber = (uint(keccak256(abi.encodePacked(now, msg.sender, totalTicket[nowLotteryId]))) % totalTicket[nowLotteryId]) +1; //토탈티켓이 1이면 랜덤번호는 0으로 시작하므로 1을 더해줌
    for (uint256 i; i < lotteryEnterAddressList[nowLotteryId].length; i++) {
      if(count + enterPassAmounts[nowLotteryId][i] >= randomNumber){
        lotteryWinHistory[nowLotteryId].push(lotteryEnterAddressList[nowLotteryId][i]);
        return;
      }
      count = count + enterPassAmounts[nowLotteryId][i];
    }
  }

 }