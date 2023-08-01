require("@nomiclabs/hardhat-ethers");
require("@openzeppelin/hardhat-upgrades");
require("@nomiclabs/hardhat-etherscan");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  abiExporter: {
    path: "./abi",
    clear: false,
    flat: true,
    // only: [],
    // except: []
  },
  solidity: {
    compilers: [
      {
        version: "0.7.6",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
        contractSizer: {
          alphaSort: true,
          runOnCompile: true,
          disambiguatePaths: false,
        },
      },
      {
        version: "0.8.9",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.8.0",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
      {
        version: "0.6.12",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
  defaultNetwork: "testnet",
  networks: {
    hardhat: {},
    ropsten: {
      url: `https://ropsten.infura.io/v3/84842078b09946638c03157f83405213`,
      accounts: [
        "8dc41ee3b6b33c1d96a34e0a3462bfa967809f8900  efe42aa6ed1e6171e74fdd",
      ],
    },
    bsc_test: {
      url: `https://data-seed-prebsc-2-s2.binance.org:8545`,
      accounts: [
        "",
      ],
    },

    rinkeby: {
      url: `https://rinkeby.infura.io/v3/84842078b09946638c03157f83405213`,
      accounts: [
        "",
      ],
    },
    ftmtest: {
      url: `https://rpc.testnet.fantom.network/`,
      accounts: [
        "",
      ],
    },
    dyno: {
      url: `https://rpctest.dynochain.io/`,
      accounts: [
        "",
      ],
    },
  },
  etherscan: {
    apiKey: {
      ropsten: "1RF6WGPIETERDRID3C5RB1PXQ1JU5JZQMP",
      rinkeby: "1RF6WGPIETERDRID3C5RB1PXQ1JU5JZQMP",
      bscTestnet: "37A4CA3UEI9Z61TDGX7EX5S4G65Y88H1CP",
      dyno: "bc658a4e-1cbd-4c88-a747-ee2394efad63",
    },
    customChains: [
      {
        network: "dyno",
        chainId: 7364,
        urls: {
          apiURL: "https://testnet.dynoscan.io/api",
          browserURL: "https://testnet.dynoscan.io/",
        },
      },
      {
        network: "bsc_test",
        chainId: 97,
        urls: {
          apiURL: "https://testnet.bscscan.com/api",
          browserURL: "https://testnet.bscscan.com/",
        },
      },
    ],
  },
};
