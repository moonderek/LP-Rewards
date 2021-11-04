const { ethers } = require("hardhat");
const { use, expect } = require("chai");
const { solidity } = require("ethereum-waffle");

use(solidity);

describe("LiquidityRewards", function () {
  let myContract;

  before((done) => {
    setTimeout(done, 2000);
  });

  describe("LiquidityRewards", function () {
    it("Should deploy LiquidityRewards", async function () {
      const OneMonthNFT = await ethers.getContractFactory("OneMonthNFT");
      const oneMonthNFT = await OneMonthNFT.deploy();

      const LiquidityRewards = await ethers.getContractFactory(
        "LiquidityRewards"
      );

      myContract = await LiquidityRewards.deploy(oneMonthNFT.address, 50, 50);
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
