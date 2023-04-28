// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./Game.sol";

contract Upgradeable is Game {
    function returnString() public pure returns(string memory){
        return "i am upgradeable contract!";
    }
}