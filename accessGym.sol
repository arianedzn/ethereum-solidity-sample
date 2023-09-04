// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract AccessGym {

    string fName;
    string lName;
    uint256 timeIn;
    uint256 timeOut;
    string fullName;

    mapping (address => bool) accessValid;

    function AccessGymInAndOut(address _address, string memory _fName, string memory _lName) public {
        fName = _fName;
        lName = _lName;
        fullName = string.concat("Full Name:", fName, " ", lName);
        if( accessValid[_address] == true) {
            accessValid[_address] = false;
                timeOut = block.timestamp;
        } else if ( accessValid[_address] = true ) {
                timeIn = block.timestamp;
        }
    }

    function getStatus(address _address)public view returns (bool, string memory, string memory, address, uint256, uint256) {
        return (accessValid[_address], fName, lName, _address, timeIn, timeOut);
    }

    function getInfo(address _address) public view returns (bool, string memory) {
        return (accessValid[_address], fullName);
    }
}