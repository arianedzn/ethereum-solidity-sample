// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;


contract Practice {

    uint256 public nike = 100;

    mapping(string => bool) vouchers;
    mapping(address => uint256) public nikeBought;

    struct Voucher {
        string name;
        string description;
    }
    
    address[] public buyerAddresses;
            
    Voucher[] voucherList;

    function createVoucer(string memory _voucherName, string memory _description) public {
        vouchers[_voucherName] = true;
        voucherList.push(Voucher(_voucherName, _description));
    }

    function getVoucherDetails(uint256 _index) public view returns (string memory, string memory) {
        Voucher memory voucher = voucherList[_index];
        return (voucher.name , voucher.description);
    }

    function updateVoucherDetails(uint256 _index, string memory newVoucherName, string memory newDescription) public {
        voucherList[_index].name = newVoucherName;
        voucherList[_index].description = newDescription;
    }

    function deleteVoucher(uint256 _index) public {
        delete voucherList[_index];
    }

    function getAllVouchers() public view returns(Voucher[] memory) {
        return voucherList;
    }

    function buyNike(uint256 amount, address buyerAddress) public {
        nike -= amount;
        nikeBought[buyerAddress] += amount;

        buyerAddresses.push(buyerAddress);
    }

    function getAllBuyers() public view returns(address[] memory) {
        return buyerAddresses;
    }

}