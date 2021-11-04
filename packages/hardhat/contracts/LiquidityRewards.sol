//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
// import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract LiquidityRewards is Ownable {


  struct UserInfo {
    uint256 oldestActiveDepositBlock;
    uint amount;
    // uint listPointer. not needed
  }

   struct PoolInfo {
      IERC20 lpToken; // Address of LP token contract.
      uint256 allocPoint; // How many allocation points assigned to this pool. SUSHIs to distribute per block.
      uint256 lastRewardBlock; // Last block number that SUSHIs distribution occurs.
      uint256 accSushiPerShare; // Accumulated SUSHIs per share, times 1e12. See below.
  }


  // mapping (address => UserInfo) public userInfo; // liquidityToOwner[msg.sender] = ProviderInfo.id
  mapping(uint256 => mapping(address => UserInfo)) public userInfo;

  PoolInfo[] public poolInfo;


  string public purpose = "Hi Mom!!!";


  address public oneMonthAddr; // nft reward after 1 months of liquidity
  address public twoMonthAddr; // nft reward after 2 months of liquidity
  address public sixMonthAddr; // nft reward after 6 months of liquidity

  uint16 public lowerAmountBoundary; // minumum amount required to deposit for tier 1

  IERC20 public lpToken;
  uint16 public burnReward; // reward for burning NFT
  uint16 public tokenAmountRequired;
  
  uint256 public startBlock;

  // Total allocation poitns. Must be the sum of all allocation points in all pools.
  uint256 public totalAllocPoint = 0;

  event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
  event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);

  event OneMonthNFTMinted(uint256 indexed tokenId, address indexed reciptient);
  event NFTBurnedMintedLiquidity(uint256 indexed tokenId, address indexed reciptient);
  
  event SetPurpose(address sender, string purpose);


  constructor(
    
    // address _oneMonthAddr,
    // address _twoMonthAddr,
    // address _sixMonthAddr,
    // IERC20 lpToken,
    // uint16 _burnReward,
    // uint16 _tokenAmountRequired
    // uint256 _startBlock,

  ) {
    setPurpose(purpose);
    // oneMonthAddr = _oneMonthAddr; 
    // twoMonthAddr = _twoMonthAddr; 
    // sixMonthAddr = _sixMonthAddr; 
    // IERC20 lpToken,
    // burnReward = _burnReward;
    // uint256 _startBlock,

  }

  using SafeMath for uint256;



  function setPurpose(string memory _newPurpose) public {
    purpose = _newPurpose;
    console.log(msg.sender,"set purpose to",purpose);
    emit SetPurpose(msg.sender, purpose);
  }

  // Sushiswap
  // Deposit LP tokens to MasterChef for SUSHI allocation.
  function deposit(uint256 _pid, uint256 _amount) public {
    PoolInfo storage pool = poolInfo[_pid];
    UserInfo storage user = userInfo[_pid][msg.sender];
    // updatePool(_pid);

    if (user.amount > 0) {
        // uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);
        // safeSushiTransfer(msg.sender, pending);
        user.amount = user.amount.add(_amount);
    }

    if (user.amount == 0) {
         user.oldestActiveDepositBlock = block.timestamp;
    }

    // pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
    user.amount = user.amount.add(_amount);
    emit Deposit(msg.sender, _pid, _amount);
  }

   // Withdraw LP tokens from MasterChef.
  function withdraw(uint256 _pid, uint256 _amount) public {
    // PoolInfo storage pool = poolInfo[_pid];
    UserInfo storage user = userInfo[_pid][msg.sender];
    require(user.amount >= _amount, "withdraw: not good");
    // updatePool(_pid);

    // check if transaction is pending for this scope?
    // uint256 pending = user.amount.mul(pool.accSushiPerShare).div(1e12).sub(user.rewardDebt);

    // safeSushiTransfer(msg.sender, pending);
    user.amount = user.amount.sub(_amount);
    // user.rewardDebt = user.amount.mul(pool.accSushiPerShare).div(1e12);

    if(lowerAmountBoundary > user.amount){  
       user.oldestActiveDepositBlock = 0;
    }

    // pool.lpToken.safeTransfer(address(msg.sender), _amount);
    emit Withdraw(msg.sender, _pid, _amount);
    }

  function mintOneMonthNFT(uint256 _pid) public {
    UserInfo storage user = userInfo[_pid][msg.sender];

    require(lowerAmountBoundary < user.amount, "Not enough tokens");

    // require() // find liquidity on uniswap 
    // require() // liquidity is found in mapping
    
    // uint amountSince = block.timestamp - user.oldestActiveDepositBlock
    
    require(block.timestamp < user.oldestActiveDepositBlock + 30 days, "Not enough time has passed"); //https://ethereum.stackexchange.com/questions/5924/how-do-ethereum-mining-nodes-maintain-a-time-consistent-with-the-network/5931#5931

    // require() // time requirement (user deposited to this contract more than (1/2/6 months ago))

    // mint() NFT
    // emit OneMonthNFTMinted(msg.sender, msg.sender); 
  }

  function fakeUniswapAddLiquidity() internal pure returns (uint) {
    return 10;
  }
  


}
