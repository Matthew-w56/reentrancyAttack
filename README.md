# reentrancyAttack
 Contracts set up to demonstrate a Reentrancy Attack in a Blockchain environment

For those unfamiliar with Blockchain applications, see the "contracts" folder for
the source code.

<br>
This project is an oversimplified DAO contract, set up with the same vulnerability
as the original Ether DAO now classified as a Re-entrancy attack.  The attacker
contract takes advantage of this weakness and takes all the money from the DAO
without having the funds that it is withdrawing in the first place.

I learned a lot about the solidity language as I built this program, and how to
set up and run the environment needed.
