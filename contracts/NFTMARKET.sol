pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard{

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address payable owner; //this is going to help us to detect the owner of the contract

    uint256 listingPrice = 0.025 ether;
     constructor(){
         owner = payable(msg.sender);
     }

    struct MarketItem{
        uint itemId;
        uint256 tokenId;
        address nftContract;
        address payable owner;
        address payable seller;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated(
    uint256 indexed itemId,
    uint256 indexed tokenId,
    address indexed nftContract,
    address  owner,
    address  seller,
    uint256 price,
    bool sold
    );

    function getListingPrice() public view returns (uint256){
        return listingPrice;
    }

    function createMarketItem(
        uint256 tokenId,
        address nftContract,
        uint256 price

    ) public payable nonReentrant{
        require(price> 0 , "Price must be greater than 0");
        require(msg.value== listingPrice , "Price must be equal to the listing price");
        
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        idToMarketItem[itemId] = MarketItem(
            itemId,
            tokenId,
            nftContract,
            payable(address(0)),
            payable(msg.sender),
            price,
            false
        );

        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            tokenId,
            nftContract,
            address(0),
            msg.sender,
            price,
            false
        );

    }

     /* Creates the sale of a marketplace item */
    /* Transfers ownership of the item, as well as funds between parties */

    function createMarketSale(
        uint256 itemId ,
        address nftContract
        )public payable nonReentrant{
        uint256 price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;

        require(msg.value == price, "Please submit the asking price to sell the item");
        idToMarketItem [itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
        idToMarketItem[itemId].owner= payable(msg.sender);
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }

    /* Returns all unsold market items */
    function fetchMarketItems() public view returns (MarketItem[] memory) {
      uint itemCount = _itemIds.current();
      uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
      uint currentIndex = 0;

      MarketItem[] memory items = new MarketItem[](unsoldItemCount);
      for (uint i = 0; i < itemCount; i++) {
        if (idToMarketItem[i + 1].owner == address(0)) {
          uint currentId = idToMarketItem[i + 1].itemId;
          MarketItem storage currentItem = idToMarketItem[currentId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }
      return items;
    }

     /* Returns only items that a user has purchased */
    function fetchMyNFTs() public view returns (MarketItem[] memory) {
      uint totalItemCount = _itemIds.current();
      uint itemCount = 0;
      uint currentIndex = 0;

      for (uint i = 0; i < totalItemCount; i++) {
        if (idToMarketItem[i + 1].owner == msg.sender) {
          itemCount += 1;
        }
      }

      MarketItem[] memory items = new MarketItem[](itemCount);
      for (uint i = 0; i < totalItemCount; i++) {
        if (idToMarketItem[i + 1].owner == msg.sender) {
          uint currentId = idToMarketItem[i + 1].itemId;
          MarketItem storage currentItem = idToMarketItem[currentId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
        }
      }
      return items;
    } 


    function fetchItemCreated() public view returns (MarketItem[] memory) {
      uint totalItemCount = _itemIds.current();
      uint itemCount = 0;
      uint currentIndex = 0;

        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == msg.sender) {
                itemCount += 1;
                itemCount += 1;
            }
            
            }

            MarketItem[] memory items = new MarketItem[](itemCount);
            for (uint i = 0; i < totalItemCount; i++) {
                if (idToMarketItem[i + 1].seller == msg.sender) {
                    uint currentId = idToMarketItem[i + 1].itemId;
                    MarketItem storage currentItem = idToMarketItem[currentId];
                    items[currentIndex] = currentItem;
                    currentIndex += 1;
                }
            }

            return items;
    }


}