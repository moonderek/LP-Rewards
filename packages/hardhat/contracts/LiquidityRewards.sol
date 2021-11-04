//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract LiquidityRewards is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  struct UserInfo {
    uint256 oldestActiveDepositBlock;
    uint amount;
  }

  mapping(uint256 => mapping(address => UserInfo)) public userInfo;

  address public oneMonthAddr; // nft reward after 1 months of liquidity
  uint16 public tokenAmountRequired; // minumum amount required to deposit be eligible to mint nft
  uint16 public burnReward; // reward for burning NFT
  IERC20 public lpToken; 


  event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
  event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

  event OneMonthNFTMinted(uint256 indexed tokenId, address indexed reciptient);
  event NFTBurnedMintedLiquidity(uint256 indexed tokenId, address indexed reciptient);

  event SetPurpose(address sender, string purpose);


  constructor(
    address _oneMonthAddr,
    // IERC20 lpToken,
    uint16 _burnReward,
    uint16 _tokenAmountRequired

  ) {
    oneMonthAddr = _oneMonthAddr; 
    // IERC20 lpToken,
    burnReward = _burnReward;
    tokenAmountRequired = _tokenAmountRequired;
  }


  // Deposit LP tokens
  function deposit(uint256 _pid, uint256 _amount) public {
    UserInfo storage user = userInfo[_pid][msg.sender];

    if (user.amount == 0) {
      user.oldestActiveDepositBlock = block.timestamp;
    }

    // if user has already deposited LP but are below lowerAmountBoundary
    if (user.amount + _amount > tokenAmountRequired && user.amount < tokenAmountRequired) {
      user.oldestActiveDepositBlock = block.timestamp;
    }

    lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
    user.amount = user.amount.add(_amount);
    emit Deposit(msg.sender, _pid, _amount);
  }

   // Withdraw LP tokens
  function withdraw(uint256 _pid, uint256 _amount) public {
    UserInfo storage user = userInfo[_pid][msg.sender];
    require(user.amount >= _amount, "withdraw: not good");

    user.amount = user.amount.sub(_amount);
    lpToken.safeTransferFrom(address(this), address(msg.sender), _amount);

    if(tokenAmountRequired > user.amount){  
       user.oldestActiveDepositBlock = 0;
    }

    emit Withdraw(msg.sender, _pid, _amount);
  }

  function mintOneMonthNFT(uint256 _pid) public {
    UserInfo storage user = userInfo[_pid][msg.sender];

    require(tokenAmountRequired > user.amount, "Not enough tokens");
    require(block.timestamp < user.oldestActiveDepositBlock + 30 days, "Not enough time has passed"); //https://ethereum.stackexchange.com/questions/5924/how-do-ethereum-mining-nodes-maintain-a-time-consistent-with-the-network/5931#5931

    // mint() NFT
    // emit OneMonthNFTMinted(msg.sender, msg.sender); 
  }

}
