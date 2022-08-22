// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

//Test contract representing a DAO, for learning purposes
//Currently it is set up to be attacked by a Reentrancy attack
contract DaoLearning {

    //Storage of the DAO contract's owner, and a list of members
    //Possible future feature: store the owner as a normal member, rather
    //  than an owner, for the same reasons that DAOs exist in the first place
    address payable owner;
    mapping(address => Member) members;

    //Struct for a member, which is just a balance for now
    struct Member {
        uint64 balance;
    }

    //Modifier that requires that a function is passed a non-zero value
    modifier hasValue() {
        require(msg.value > 0, "You must attatch value to this transaction!");
        _;
    }

    //Constructs the DAO contract, saving the owner
    constructor() {
        owner = payable(msg.sender);
    }

    //Returns the address of the DAO contract's owner
    function getOwner() public view returns(address payable) {
        return owner;
    }

    //Receives payment from other addresses, and credits them tokens
    function mintTokens() public payable hasValue {
        members[msg.sender].balance += uint64(msg.value);
    }

    //Returns the balance of the address that called the function
    function checkBalance() public view returns(uint64) {
        return members[msg.sender].balance;
    }

    //Returns the total balance controlled by this contract
    function contractBalance() public view returns(uint256) {
        return address(this).balance;
    }

    //Sends money back to an address, and debits their token balance
    //Note: This is currently set up for a Reentrancy attack.  This is
    //      a historically terrible way to do things.
    function withdraw(uint64 amount) public {
        //Require that the amount is between zero, and the address' balance
        require(amount > 0, "Enter a valid amount (0 < amount <= balance)");
        require(amount <= members[msg.sender].balance, "You do not have the sufficient funds for this");

        //Send the address their money
        payable(msg.sender).transfer(amount);

        //Debit their token balance with the DAO
        members[address(msg.sender)].balance -= amount;
    }

}
