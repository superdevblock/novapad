const { ethers, upgrades } = require("hardhat");

async function main() {
  const gas = await ethers.provider.getGasPrice();
  const PoolManager = await ethers.getContractFactory("PoolManager");
  console.log("Deploying PoolManager...");
  const poolManager = await upgrades.deployProxy(
    PoolManager,
    [
      "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd",
      "0xa75c80e7Ca70505AAB6062cF15A2cFC71b6138C0",
    ],
    {
      gasPrice: gas,
      initializer: "initialize",
    }
  );
  await poolManager.deployed();
  console.log("PoolManager Contract deployed to:", poolManager.address);
  await poolManager.initializeTopPools();
  console.log("Initialized:");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
