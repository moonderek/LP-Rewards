pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract LiquidityRewards is Ownable {

  event NFTMinted(uint256 indexed tokenId, address indexed reciptient);
  event NFTBurnedMintedLiquidity(uint256 indexed tokenId, address indexed reciptient);

  event SetPurpose(address indexed sender, string  purpose);


  string public purpose = "Being confused!!!";

  constructor() {
    // what should we do on deploy?
    setPurpose(purpose);
  }

  function setPurpose(string memory newPurpose) public {
      purpose = newPurpose;
      console.log(msg.sender,"set purpose to",purpose);
      emit SetPurpose(msg.sender, purpose);
  }
}
