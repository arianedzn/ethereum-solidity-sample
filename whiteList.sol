// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";

error accessError(bool access);

contract GymAccess {
    bool access; 
    address public owner;

    mapping (address => bool) whiteListedAddresses; 
    mapping (address => bool) accessValid;

    constructor() {
        owner = msg.sender;
        whiteListedAddresses[msg.sender] = true;
        console.log("The owner of this addres is : " , msg.sender);
    }

    modifier AccessGrant {
        if(!whiteListedAddresses[msg.sender] ) {   
            revert accessError(access);
        }
        _;
    }

    function addUserToWhitelist (address _addressToWhitelist) public {   
        whiteListedAddresses[_addressToWhitelist] = true;
    }

    function verifyUserWhitelist(address _address) public view returns (bool) {  
        bool IsUserWhitelisted = whiteListedAddresses[_address];
        return IsUserWhitelisted;
    }

    function AccesGymInAndOut() public AccessGrant { //4 
        if( accessValid[msg.sender] == true ) {
            accessValid[msg.sender] = false;
        } else accessValid[msg.sender] = true;
    }

    function isLoggedIn(address _address) public view returns (bool) {   
        return  accessValid[_address]; 
    }
}