require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

 const privateKey = ""
 
module.exports = {
  networks: {
    hardhat: {
    },
    klaytn: {
      url: "https://api.baobab.klaytn.net:8651",
      accounts: [privateKey],
      gas: 20000000,
      chainId: 1001
    }
  },
  solidity: "0.5.6",
};
