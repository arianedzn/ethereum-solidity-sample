// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

error NotOwner();
error BurgerOutOfStock(uint256 burger, uint256 siopao, uint256 toron);
error storeStillClosed(uint end);
error storeIsClosed(uint closingTime);
error accessError(bool access);


contract SariSariStore {
    uint256 siopao = 100;
    uint256 toron = 100;
    uint256 burger = 20;
    uint end;
    uint closingTime;
    bool access;

    address public owner;

    mapping (address => uint256) public siopaoBought;
    mapping (address => uint256) public toronBought;
    mapping (address => bool) whiteListedAddresses;
    mapping (address => bool) accessValid;

    constructor() {
        owner = msg.sender;
        whiteListedAddresses[msg.sender] = true;
        console.log("The owner of this address is : " , msg.sender);
    }

    modifier onlyOwner {
        if(msg.sender != owner) {
            revert NotOwner();
        }
        _;
    }

    // modifier onlyOwner {
    //     require(msg.sender == owner, "Sender is not owner!");
    //     _;
    // }

    modifier outOfStock {
        if(burger == 0) {
            revert BurgerOutOfStock(burger, siopao, toron);
        }
        _;
    }

    modifier setTimeLock {
        if( block.timestamp > end) {
            revert storeStillClosed(end);
        }
        _;
    }

    modifier storeKey {
        if(block.timestamp > closingTime) {
            revert storeIsClosed(closingTime);
    }
    _;
    }

    modifier AccessGrant {
        if(!whiteListedAddresses[msg.sender] ) {
            revert accessError(access);
        }
        _;
    }

    function buySiopao (uint256 _siopao) public payable {
        require(msg.value >= 1 gwei, "Insufficient funds!");
        siopao = siopao - _siopao;
        siopaoBought[msg.sender] = _siopao;
    }

    function balanceOf() external view returns(uint256) {
        return address(this).balance;
    }

    function withdraw() public onlyOwner {
        require(msg.sender == owner, "Sender is not owner!");
       // payable(msg.sender).transfer(address(this).balance);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    function buyToron (uint256 _toron) public {
        toron = toron - _toron;
        toronBought[msg.sender] += _toron;
    }

    function Buy1Take1Burger() public outOfStock storeKey{
        burger = burger - 2;

    }

    function Siopao () public view returns(uint256) {
        return siopao;
    }
    
    function Toron () public view returns(uint256) {
        return toron;
    }

    function Burger() public view returns(uint256) {
        return burger;
    }

    function getBlockStamp() public view returns(uint256) {
        return block.timestamp;
    }

    function restockBurger(uint256 quantity) public {
        if(burger == 0) {
            burger = quantity;
        }
        require(quantity <= 20, "Quantity should be less than 20");
    }


    function timeLock(uint256 time) public onlyOwner {
        end = block.timestamp + time;
    }

      function getTimeLeft() public view returns(uint256 time) {
        require(end >= block.timestamp, "Time is Over");
        return end - block.timestamp;
        // if(end == 0) {
        //     end = time;
        // }
        // require(time == 0, "Time is over!");
    }

     function getTimeStamp()public view returns(uint256) {
        return block.timestamp;
    }

    function openStore(uint256 time) public {
        closingTime = block.timestamp + time;
        require(msg.sender == owner, "Not owner");
    }

    function getOpenTimeLeft() public view returns(uint256) {
        require(closingTime >= block.timestamp , "Store is closed.");
        return closingTime - block.timestamp;
    }

    function addUserToWhitelist (address _addressToWhitelist) public {
        whiteListedAddresses[_addressToWhitelist] = true;
    }

    function verifyUserWhitelist(address _address) public view returns (bool) {
        bool IsUserWhiteListed = whiteListedAddresses[_address];
        return IsUserWhiteListed;
    }

    function AccessStoreInAndOut() public AccessGrant {
        if( accessValid[msg.sender] == true) {
            accessValid[msg.sender] = false;
        } else accessValid[msg.sender] = true;
    }
    function isLoggedIn (address _address) public view returns (bool) {
        return accessValid[_address];
    }
}