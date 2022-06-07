require("@nomiclabs/hardhat-waffle")

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/a41830bca53d48beaee6acb12533b9fe",
      accounts: ['cd4781f0f0b2d511b6c3049769af3bbfbb4b4ea748f18af9728dcb2bb66ca727']
    },

  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
