//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Game} from "../src/Game.sol";

contract GameInternal is Game, Test {
    Game game;
    address me;
    address user;

    function setUp() public {
        game = new Game();
        uint256 myKey = 0x1111;
        uint256 userKey = 0x2222;
        me = vm.addr(myKey);
        user = vm.addr(userKey);
        vm.startPrank(me);
    }

    function test_tokenURI() external {
        initialize("uri");
        mint(user);
        assertEq(tokenURI(1), "uri1");
    }
}
