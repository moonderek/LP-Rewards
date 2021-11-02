pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract LiquidityRewards is Ownable {

  event OneMonthNFTMinted(uint256 indexed tokenId, address indexed reciptient);
  event NFTBurnedMintedLiquidity(uint256 indexed tokenId, address indexed reciptient);
  event SetPurpose(address sender, string purpose);

  address public oneMonthAddr; // nft after 1 months of liquidity
  address public twoMonthAddr; // nft after 2 months of liquidity
  address public sixMonthAddr; // nft after 6 months of liquidity
  address public tokenA; // liquidity pool tokenA
  address public tokenB; // liquidity pool tokenB
  uint16 public burnReward; // reward for burning NFT
  uint16 public tokenAmountRequired;

  struct LiquidityStruct {
    uint oldestActiveDepositDate;
    uint liquidityBalance;
    uint listPointer;
  }

  LiquidityStruct[] public liquidityList;

  mapping (address => LiquidityStruct) public liquidityToOwner; // liquidityToOwner[msg.sender] = ProviderInfo.id


  string public purpose = "Being confused!!!";

  constructor(
    // address _oneMonthAddr,
    // address _twoMonthAddr,
    // address _sixMonthAddr,
    // address _tokenA,
    // address _tokenB,
    // uint16 _burnReward,
    // uint16 _tokenAmountRequired
  ) {
    setPurpose(purpose);
    // oneMonthAddr = _oneMonthAddr; 
    // twoMonthAddr = _twoMonthAddr; 
    // sixMonthAddr = _sixMonthAddr; 
    // tokenA = _tokenA; 
    // tokenB = _tokenB; 
    // burnReward = _burnReward;
    // tokenAmountRequired = _tokenAmountRequired;
  }

  function setPurpose(string memory _newPurpose) public {
    purpose = _newPurpose;
    console.log(msg.sender,"set purpose to",purpose);
    emit SetPurpose(msg.sender, purpose);
  }

  function isLiquidity(address _liquidityAddress) public view returns(bool isIndeed){
    if(liquidityList.length  == 0) return false;
    return false; //fix
  }

  function addLiquidity(uint32 _amount) public {
    // (1) call uniswap contract to add liquidity & confirm it was successful 
    // https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/LiquidityManagement.sol

    // if msg.sender already has liquidity -> update struct
    if(isLiquidity(msg.sender) == true) revert();

    uint liquidityBalance = fakeUniswapAddLiquidity();
    uint id = liquidityList.length - 1;

    liquidityList.push(LiquidityStruct(block.timestamp, _amount, id));

    liquidityToOwner[msg.sender].listPointer = id;
    liquidityToOwner[msg.sender].liquidityBalance = liquidityBalance;
    liquidityToOwner[msg.sender].oldestActiveDepositDate = block.timestamp;

  }

  function removeLiquidity(uint32 _amount) public {

  }

  function mintOneMonthNFT() public {
    // require() // find liquidity on uniswap 
    // require() // liquidity is found in mapping
    // require() // time requirement (user deposited to this contract more than (1/2/6 months ago))
    // tokenId = NFTContract.mint(msg.sender)
    // emit OneMonthNFTMinted(msg.sender, msg.sender); 
  }

  function fakeUniswapAddLiquidity() internal pure returns (uint) {
    return 10;
  }
  


}
