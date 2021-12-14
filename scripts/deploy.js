
const hre = require("hardhat");

async function main() {

  const KlayMusuem = await hre.ethers.getContractFactory("KlayMusuem");
  const klayMusuem = await KlayMusuem.deploy();

  await klayMusuem.deployed();

  console.log("klayMusuem deployed to:", klayMusuem.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
