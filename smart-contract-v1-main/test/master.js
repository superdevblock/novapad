const { expect } = require("chai");
// const { ethers, upgrades } = require('hardhat');

const version = 1;
const kycPrice = 0.001;
const auditPrice = 0.002;
const masterPrice = 0.001;
const privatemasterPrice = 0.002;
const fairmasterPrice = 0.003;
const IsEnabled = true;
const contributeWithdrawFee = 1000; //1% ~ 100

// admin wallet = 0x71195aC7A1dAA8e66d7B38C16860F69B7a20e797

async function test() {
    // pairMaster = await (await ethers.getContractFactory("PresalePool")).deploy();
    // console.log("PresalePool deployed to:", pairMaster.address);
    // expect(pairMaster.address).to.exist;

    // privatepairMaster = await (await ethers.getContractFactory("PrivatePool")).deploy();
    // console.log("Private Pool deployed to:", privatepairMaster.address);
    // expect(privatepairMaster.address).to.exist;

    // fairpairMaster = await (await ethers.getContractFactory("FairPool")).deploy();
    // console.log("FairPool Pool deployed to:", fairpairMaster.address);
    // expect(fairpairMaster.address).to.exist;

    // const PairManager1 = await (await ethers.getContractFactory("PoolManager"));
    // console.log("PoolManager1 deploying....");

    // const PairManager2 = await upgrades.deployProxy(PairManager1,[],{ initializer: 'initialize' });
    // await PairManager2.deployed();
    // console.log('PairManager2 deployed to:', PairManager2.address);

    
    // const pairFactory1 = await ethers.getContractFactory('PoolFactory');
    // console.log('Deploying pairFactory1...');

    // const pairFactory2 = await upgrades.deployProxy(pairFactory1,
    //     [
    //         "0xb52c6f30CE21F95919dD9D9EF5f5BA12133c2921",
    //         "0xAd08c500E7b180E4f762E2aAeB2d4D9803a2273e",
    //         "0x762860BbBc43eb1C611076f18668d7ce6b23D4E6",
    //         "0x46751862B49E6273f9669216A3072b77a3178b65",
    //         version,
    //         ethers.utils.parseUnits(kycPrice.toString(), 18),
    //         ethers.utils.parseUnits(auditPrice.toString(), 18),
    //         ethers.utils.parseUnits(masterPrice.toString(), 18),
    //         ethers.utils.parseUnits(privatemasterPrice.toString(), 18),
    //         ethers.utils.parseUnits(fairmasterPrice.toString(), 18),
    //         contributeWithdrawFee,
    //         IsEnabled
    //     ], { initializer: 'initialize' });
    // await pairFactory2.deployed();
    // console.log('pairFactory2 deployed to:', pairFactory2.address);

   
    // Token = await (await ethers.getContractFactory("TestDND")).deploy();
    // console.log("Token deployed to:", Token.address);


    // let ownerset = await pairFactory2.setPoolOwner(pairFactory2.address);
    // let check = await ownerset.wait();
    // console.log("onwer set is:", check.status);

    // let addAdminPoolFactory = await PairManager2.addAdminPoolFactory(pairFactory2.address);
    // let check1 = await addAdminPoolFactory.wait();
    // console.log("addAdminPoolFactory set is:", check1.status);

    // LockContract = await (await ethers.getContractFactory("oxLaunchLocker")).deploy();
    // console.log("LockContract deployed to:", LockContract.address);
    // expect(LockContract.address).to.exist;


   


}

test();