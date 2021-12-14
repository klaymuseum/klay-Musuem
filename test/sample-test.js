// const { BigNumber } = require("@ethersproject/bignumber");
const { expect } = require("chai");
const { ethers } = require("hardhat");
// const { BigNumber, BigNumberish, Contract } = require("ethers");

var price = 1;
var whitelistPrice = 1;
var maxMintAmount = 10;
var maxMintAmountWhitelist = 5;
var maxSupply = 2000;

describe("KlayMusuem", function () {
  let MyContract;
  let myContract;
  let DrinkContract;
  let drinkContract;
  let LotteryContract;
  let lotteryContract;
  let owner; //배포자
  let addr1; //유저1
  let addr2;
  let addr3;
  let addr4;
  let addrs;
  beforeEach(async () => {
    MyContract = await ethers.getContractFactory("KlayMusuem");
    [owner, addr1, addr2,addr3,addr4, ...addrs] = await ethers.getSigners();
    myContract = await MyContract.deploy("a","aa");
    DrinkContract = await ethers.getContractFactory("WelcomDrink");
    drinkContract = await DrinkContract.deploy("a","aa",myContract.address);
    LotteryContract = await ethers.getContractFactory("Lottery");
    lotteryContract = await LotteryContract.deploy(myContract.address);

    await myContract.deployed();
    await drinkContract.deployed();
    await lotteryContract.deployed();
  })

  //it이 실행될 때마다 초기화 됨

  // it("1. 화리 개별등록 ->화리대상자 민팅", async function () {
  //   var mintAmount = 1;
  //   await myContract.connect(owner).insertwhitelistUser(addr1.address);
  //   await myContract.connect(addr1).userMint(mintAmount,{value: whitelistPrice * mintAmount});
  //   expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
  // });
  // it("2. 화리리스트 목록 등록 -> 화리 대상자 민팅", async function () {
  //   var mintAmount = 1;
  //   await myContract.connect(owner).insertwhitelistUsers([addr1.address,addr2.address]);
  //   await myContract.connect(addr2).userMint(mintAmount,{value: whitelistPrice * mintAmount});
  //   expect(await myContract.balanceOf(addr2.address)).to.equal(mintAmount);
  // });
  // it("3. 화리리스트 목록 등록 -> 화리 대상자 아닌사람 민팅", async function () {
  //   var mintAmount = 1;
  //   await myContract.connect(owner).insertwhitelistUsers([addr1.address,addr2.address]);
  //   await expect(myContract.connect(addr3).userMint(mintAmount,{value: whitelistPrice * mintAmount})).to.be.reverted;
  // });
  // it("4. 화리리스트 목록 등록 -> 화리 대상자 최대 민팅량 민팅", async function () {
  //   var mintAmount = 1;
  //   await myContract.connect(owner).insertwhitelistUsers([addr1.address,addr2.address]);
  //   await expect(myContract.connect(addr1).userMint(maxMintAmountWhitelist + 1,{value: whitelistPrice * maxMintAmountWhitelist + 1})).to.be.reverted;
  // });



  it("1.일반유저 민팅", async function () {
    var mintAmount = 1;
    await myContract.setOnlyWhitelisted(false);
    await myContract.mintUnPause();
    await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
    expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
  });
  // it("2.일반유저 pause 된 상태에서 민팅", async function () {
  //   var mintAmount = 1;
  //   await myContract.setOnlyWhitelisted(false);
  //   await myContract.connect(owner).pause();
  //   await expect(myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount})).to.be.reverted;
  // });
  // it("3.일반유저 0개 민팅", async function () {
  //   var mintAmount = 0;
  //   await myContract.setOnlyWhitelisted(false);
  //   await expect(myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount})).to.be.reverted;
  // });
  // it("4.일반유저 최대 민팅갯수 넘김", async function () {
  //   await myContract.setOnlyWhitelisted(false);
  //   await expect(myContract.connect(addr1).userMint(maxMintAmount + 1,{value: price * maxMintAmount + 1})).to.be.reverted;
  // });

  // it("오너 사전민팅 ", async function () {
  //   var mintAmount = 100;
  //   await myContract.connect(owner).preMint(owner.address,mintAmount);
  //   expect(await myContract.balanceOf(owner.address)).to.equal(mintAmount);
  // });





  // it("1.패스 민팅 -> welcomeDrink 민팅", async function () {
  //   var mintAmount = 6;
  //   await myContract.setOnlyWhitelisted(false);
  //   // 패스 민팅
  //   await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
  //   expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
  //   //드링크 민팅
  //   await drinkContract.connect(addr1).airdropMint(mintAmount);
  //   expect(await drinkContract.balanceOf(addr1.address)).to.equal(mintAmount)
  // });
  // it("2.welcomeDrink 민트가능 갯수 조회", async function () {
  //   var mintAmount = 6;
  //   await myContract.setOnlyWhitelisted(false);
  //   // 일반민팅
  //   await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
  //   expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
  //   var drinkMintAmount = 2
  //   await drinkContract.connect(addr1).airdropMint(drinkMintAmount);
  //   expect(await drinkContract.connect(addr1).getMintableAmount()).to.equal(mintAmount-drinkMintAmount);
  // });

  // //프리민트 -> pause 품 -> 화리민팅error
  // //프리민트 -> pause 품 -> setMaxSupply 변경
  // it("1.프리민트 -> 화리민팅 맥스서플라이 오류", async function () {
  //   var mintAmount = maxSupply/10;
  //   var repeatCount = 10;
  //   for(var i=1; i <= repeatCount; i++) {
  //     await myContract.connect(owner).preMint(owner.address,mintAmount);
  //   }
  //   expect(await myContract.balanceOf(owner.address)).to.equal(maxSupply);
    
  //   await myContract.setOnlyWhitelisted(false);
  //   await expect(myContract.connect(addr1).userMint(1,{value: price * 1})).to.be.reverted;
  // });
  // it("1.프리민트 -> 맥스서플라이 변경 -> 일반 민팅 가능", async function () {
  //   var mintAmount = maxSupply/10;
  //   var repeatCount = 10;
  //   for(var i=1; i <= repeatCount; i++) {
  //     await myContract.connect(owner).preMint(owner.address,mintAmount);
  //   }
  //   expect(await myContract.balanceOf(owner.address)).to.equal(maxSupply);
    
  //   await myContract.setOnlyWhitelisted(false);
  //   await myContract.connect(owner).setMaxSupply(maxSupply + 1);
  //   expect(await myContract.maxSupply()).to.be.equal(2001);
  //   await myContract.connect(addr1).userMint(1,{value: price * 1});
  //   expect(await myContract.balanceOf(addr1.address)).to.equal(1);
  // });
  it("1.패스 민팅 -> 패스 보유자 추첨자 등록 -> 추첨 허용 ->당첨자 조회", async function () {
    var mintAmount = 10;
    await myContract.setOnlyWhitelisted(false);
    await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
    await myContract.connect(addr2).userMint(mintAmount,{value: price * mintAmount});
    expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);

    await lotteryContract.connect(owner).lotteryUnPause();
    await lotteryContract.connect(addr1).lotteryEnter();
    await lotteryContract.connect(addr2).lotteryEnter();

    await lotteryContract.connect(owner).setEnterPassAmounts([1,1]);
    await lotteryContract.connect(owner).calTotalTicket();
    
    await lotteryContract.connect(owner).drawLotteryWinner();
    var a =await lotteryContract.connect(owner).getLotteryWinnerList(1);
    console.log(a)
  });
  it("1.패스 민팅 -> 추첨자 등록 -> 추첨 허용 ->추첨 여러번 이후 조회", async function () {
    var mintAmount = 10;
    await myContract.setOnlyWhitelisted(false);
    await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
    await myContract.connect(addr2).userMint(mintAmount,{value: price * mintAmount});
    expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
    
    await lotteryContract.connect(owner).lotteryUnPause();
    await lotteryContract.connect(addr1).lotteryEnter();
    await lotteryContract.connect(addr2).lotteryEnter();
    await lotteryContract.connect(owner).setEnterPassAmounts([mintAmount,mintAmount]);
    await lotteryContract.connect(owner).calTotalTicket();

    await lotteryContract.connect(owner).drawLotteryWinner();
    await lotteryContract.connect(owner).drawLotteryWinner();
    await lotteryContract.connect(owner).drawLotteryWinner();
    var a =await lotteryContract.connect(owner).getLotteryWinnerList(1);
    console.log(a)
  });
  it("1.패스 민팅 -> 추첨자 등록 -> 추첨 허용 ->추첨 리셋 후 다음추첨", async function () {
    var mintAmount = 10;
    await myContract.setOnlyWhitelisted(false);
    await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
    await myContract.connect(addr2).userMint(mintAmount,{value: price * mintAmount});
    expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);

    await lotteryContract.connect(owner).lotteryUnPause();
    await lotteryContract.connect(addr1).lotteryEnter();
    await lotteryContract.connect(addr2).lotteryEnter();
    await lotteryContract.connect(owner).setEnterPassAmounts([mintAmount,mintAmount]);
    await lotteryContract.connect(owner).calTotalTicket();
    await lotteryContract.connect(owner).drawLotteryWinner();
    var a =await lotteryContract.connect(owner).getLotteryWinnerList(1);
    console.log(a)
    
    await lotteryContract.connect(owner).setNextLotteryId();
    await lotteryContract.connect(owner).lotteryUnPause();
    await lotteryContract.connect(addr1).lotteryEnter();
    await lotteryContract.connect(addr2).lotteryEnter();
    await lotteryContract.connect(owner).setEnterPassAmounts([mintAmount,mintAmount]);
    await lotteryContract.connect(owner).calTotalTicket();
    await lotteryContract.connect(owner).drawLotteryWinner();
    var a =await lotteryContract.connect(owner).getLotteryWinnerList(2);
    console.log(a)
  });
  it("패스 홀더 아닌사람 추첨 참여 오류", async function () {
    await lotteryContract.connect(owner).lotteryUnPause();
    await expect(lotteryContract.connect(addr1).lotteryEnter()).to.be.reverted;
  });
  it("추첨 정지일 때 신규 추첨 등록", async function () {
    var mintAmount = 10;
    await myContract.setOnlyWhitelisted(false);
    await myContract.connect(addr1).userMint(mintAmount,{value: price * mintAmount});
    expect(await myContract.balanceOf(addr1.address)).to.equal(mintAmount);
    await expect(lotteryContract.connect(addr1).lotteryEnter()).to.be.reverted;
  });
});
