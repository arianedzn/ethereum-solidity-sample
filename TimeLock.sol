// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 < 0.9.0;

error storeStillClosed(uint end);

contract TicketStore {
    uint256 public tickets = 100;
    uint end;


    modifier storeLock {
        if( block.timestamp < end) {
            revert storeStillClosed(end);
        }
        _;
    }


    function buyTickets(uint256 amount) public storeLock {
       tickets -= amount;
    }

    function getTimeStamp()public view returns(uint256) {
        return block.timestamp;
    }

    function closeTicketStore(uint256 time) public {
        end = block.timestamp + time;
    }

    function getTimeLeft() public view returns(uint256) {
        return end - block.timestamp;
    }


}