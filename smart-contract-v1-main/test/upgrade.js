const { ethers, upgrades } = require("hardhat");

const MANAGER = "0xA08e11D2e2AEF3c95FFe09A74c7D4D04A0766B4D";
const FACTORY = "0x5af573f625534af14194a001f4871ae7387afa62";



async function main() {
    const BoxV2 = await ethers.getContractFactory("PoolManager");
    console.log("Upgrading Box...");
    await upgrades.upgradeProxy(MANAGER, BoxV2);
    console.log("Box upgraded");

    // const BoxV3 = await ethers.getContractFactory("PoolFactory");
    // console.log("Upgrading Box...");
    // await upgrades.upgradeProxy(FACTORY, BoxV3);
    // console.log("Box upgraded");

    // const BoxV3 = await ethers.getContractFactory("EmberPresale");
    // console.log("Upgrading Box...");
    // await upgrades.upgradeProxy(FACTORY, BoxV3);
    // console.log("Box upgraded");

}

main();