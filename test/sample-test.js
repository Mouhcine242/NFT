const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("NFTMarket", function () {
  it("it should create and execute market sales", async function () {

    const Market = await ethers.getContractFactory("NFTMarket");
    const market = await Market.deploy();
    await market.deployed();
    const marketAdress = market.address;
    
    
    const NFT = await ethers.getContractFactory("NFT");
    const nftdeployed = await NFT.deploy(marketAdress);
    await nftdeployed.deployed();
    const nftadress = nftdeployed.address;

    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();

    const auctionPrice = ethers.utils.parseUnits('100' , 'ether') ;

    await nftdeployed.createToken("https://www.mytokenlocation.com");
    await nftdeployed.createToken("https://www.mytokenlocation2.com");

    await market.createMarketItem( 1 , nftadress, auctionPrice , {value: listingPrice});
    await market.createMarketItem(2 , nftadress, auctionPrice , {value: listingPrice});

    const [_ , buyerAddress] = await ethers.getSigners();
    await market.connect(buyerAddress).createMarketSale(1 , nftadress, {value: auctionPrice});

    const items = await market.fetchMarketItems();

    // items = await Promise.all(items.map(async (item) => {
    //   const tokenURI = await nftdeployed.tokenURI (item.tokenId);
    //   let element = {
    //     price : item.price.toString(),
    //     tokenId : item.tokenId.toString(),
    //     seller : item.seller,
    //     owner : item.owner,
    //     tokenURI 
        
    //   };
    //   return element;
    // }));

    console.log('items :',items);

   
  });
});
