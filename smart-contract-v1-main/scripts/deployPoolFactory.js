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

  const PoolFactory = await ethers.getContractFactory("PoolFactory");
  console.log("Deploying PoolFactory...");
  const poolfactory = await upgrades.deployProxy(
    PoolFactory,
    [
      "0x44b025a11fE40A72dfA55FDA5417D759bE5cdECb",
      "0xE6B0659b420d1ae431958dAE3942083D7563e862",
      poolManager.address,
      "0xb241286cae8e07cdAE47b1A240Df0a25fB3f101D",
      "1",
      "1000000000000000",
      "2000000000000000",
      "1000000000000000",
      "2000000000000000",
      "3000000000000000",
      "1000",
      "true",
    ],
    {
      gasPrice: gas,
      initializer: "initialize",
    }
  );
  await poolfactory.deployed();
  console.log("PoolFactory Contract deployed to:", poolfactory.address);
  await poolfactory.setAdminWallet(
    "0x2080F3b056978e76913efdF7F15EaB5130B7647B"
  );
  console.log("Set Admin Wallet");
  await poolfactory.setPoolOwner(poolfactory.address);
  console.log("Set Pool Owner");

  await poolManager.addAdminPoolFactory(poolfactory.address);
  console.log("addAdminPoolFactory");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
