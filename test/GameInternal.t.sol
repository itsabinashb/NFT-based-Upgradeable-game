//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Game} from "../src/Game.sol";
import  {UpgradedGame}  from "./ProxyTest.t.sol";
import "../src/MainProxy.sol";

contract GameInternal is Game, Test {
    Game game;
    address me;
    address user;
    UpgradedGame _game;
    MainProxy proxy;

    function setUp() public {
        game = new Game();
        _game = new UpgradedGame();
        //proxy = new MainProxy();
        uint256 myKey = 0x1111;
        uint256 userKey = 0x2222;
        me = vm.addr(myKey);
        user = vm.addr(userKey);
        
    }

    function test_testingInitializeVersion() public {
        vm.startPrank(me);
        //game.initialize("uri");
        console.log("Initialize version for 1st initialization:",_getInitializedVersion());
       // proxy.initialize(address(_game));
        //proxy.upgradeTo(address(_game));
        vm.stopPrank();
        vm.startPrank(address(user));
        //_game.initialize("tokenUri");
        console.log("Initialize version for 2nd initialization:",_getInitializedVersion());

    }

    function test_tokenURI() external {
       // initialize("uri");
        mint(user);
        assertEq(tokenURI(1), "uri1");
    }
}
