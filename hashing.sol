// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
pragma abicoder v2;


contract ShopVouchers {

   uint256 public ps5 = 100;

   mapping (address => uint) public ps5Bought;
   mapping (string => bool)  vouchers;

   struct Voucher {
       string name;
       string description;
   }
    
    Voucher[] vouchersList;
    address[] buyersAddress;

    function createVoucherAndActivate(string memory _voucher, string memory _description) public {
        vouchers[_voucher] = true;
        vouchersList.push(Voucher(_voucher, _description));
    }

    function updateVoucherName(uint _index, string memory newName, string memory newDescription) public {
        vouchersList[_index].name = newName;
        vouchersList[_index].description = newDescription;
    }

    function getVoucherDetails(uint256 _index)public view returns(string memory, string memory) {
        Voucher memory voucher = vouchersList[_index];
        return (voucher.name, voucher.description);
    }

    function removeVoucher(uint256 _index) public {
        delete vouchersList[_index];
    }

    function getAllVouchers() public view returns(Voucher[] memory) {
        return vouchersList;
    }

    function verifyVoucher(string memory voucherName) public view returns(bool) {
        bool isVoucherExist = vouchers[voucherName];
        return isVoucherExist;
    }

   function getKeccak(string memory voucher1, string memory voucher2) public pure returns (bool) {
       bool isEqual =  keccak256(abi.encodePacked(voucher1)) == keccak256(abi.encodePacked(voucher2));
       return isEqual;
   }

    function buyItem(uint amount, string memory voucherName) public payable {
       bool isEqual = keccak256(abi.encodePacked("SALE50")) == keccak256(abi.encodePacked(voucherName));
       bool isExist = verifyVoucher(voucherName);
        if ( isExist == true && isEqual == true  ) {
            require(msg.value >= amount * (1 ether - 0.5 * 100)  , "Price is 2 ether, not enough balance");
            ps5Bought[msg.sender] += amount;
            ps5 -= amount;
        } else {
            require(msg.value >= amount * 2 ether, "Price is 1 ether, not enough balance");
            ps5Bought[msg.sender] += amount;
            ps5 -= amount;
        }

        buyersAddress.push(address(msg.sender));
    }

    function getAllBuyers() public view returns(address[] memory) {
        return buyersAddress;
    }


}