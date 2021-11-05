const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("LiquidityRewards", function () {
  let LiquidityRewards;

  // Contract constructor args
  let lpToken;
  let tokenAmountRequired;
  let burnReward;

  let alice;
  let bob;
  let dev;
  let minter;

  let oneMonthNFTAddr;

  describe("LiquidityRewards time based nfts rewards ", function () {
    before(async () => {
      const signers = await ethers.getSigners();
      alice = signers[0];
      bob = signers[1];
      dev = signers[3];
      minter = signers[5];

      tokenAmountRequired = 1000;
      burnReward = 5000;

      // Mock NFT Contract
      const OneMonthNFTAddr = await ethers.getContractFactory("OneMonthNFT");
      oneMonthNFTAddr = await OneMonthNFTAddr.deploy();

      // Mock ERC20
      const ERC20Mock = await ethers.getContractFactory("ERC20Mock");
      lpToken = await ERC20Mock.deploy("LPToken1", "LP1", "10000000000");

      // Transfer lp token to Alice and Bob
      await lpToken.transfer(alice.address, "1000");
      await lpToken.transfer(bob.address, "1000");

      // Deploy LiquidityRewards contract
      const liquidityRewards = await ethers.getContractFactory(
        "LiquidityRewards"
      );

      LiquidityRewards = await liquidityRewards.deploy(
        oneMonthNFTAddr.address,
        lpToken.address,
        burnReward,
        tokenAmountRequired
      );
    });

    it("should set correct state variables", async function () {
      expect(tokenAmountRequired).to.equal(
        await LiquidityRewards.tokenAmountRequired()
      );
      expect(burnReward).to.equal(await LiquidityRewards.burnReward());
      expect(lpToken.address).to.equal(await LiquidityRewards.lpToken());
      expect(oneMonthNFTAddr.address).to.equal(
        await LiquidityRewards.oneMonthNFTAddr()
      );
    });

    // describe("setPurpose()", function () {
    //   it("Should be able to set a new purpose", async function () {
    //     const newPurpose = "Test Purpose";

    //     await myContract.setPurpose(newPurpose);
    //     expect(await myContract.purpose()).to.equal(newPurpose);
    //   });

    //   // Uncomment the event and emit lines in YourContract.sol to make this test pass

    //   it("Should emit a SetPurpose event ", async function () {
    //     const [owner] = await ethers.getSigners();

    //     const newPurpose = "Another Test Purpose";

    //     expect(await myContract.setPurpose(newPurpose))
    //       .to.emit(myContract, "SetPurpose")
    //       .withArgs(owner.address, newPurpose);
    //   });
    // });
  });
});
