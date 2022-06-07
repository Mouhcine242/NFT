const hre = require("hardhat");

async function main() {
 
  const NFTMARKET = await hre.ethers.getContractFactory("NFTMarket");
  const nFTMARKET = await NFTMARKET.deploy();
  await nFTMARKET.deployed();
  console.log("NFTMARKET deployed to:", nFTMARKET.address);

  const NFT = await hre.ethers.getContractFactory("NFT");
  const nft = await NFT.deploy(nFTMARKET.address);
  await nft.deployed();
  console.log("NFt deployed to:", nft.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
