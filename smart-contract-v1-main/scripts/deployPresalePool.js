const { ethers, upgrades } = require("hardhat");

async function main() {
  const PresalePool = await ethers.getContractFactory("PresalePool");
  const presalepool = await PresalePool.deploy();

  await presalepool.deployed();

  console.log(`Deployed to ${presalepool.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
