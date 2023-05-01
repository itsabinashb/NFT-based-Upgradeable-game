//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/Proxy.sol";

contract ProxyTest is Test {
    Game game;   // main contract address
    UpgradedGame _game;  // upgraded contract address
    Proxy proxy; // proxy contract address
    address me;
    address user;

    function setUp() public {
        game = new Game();   // new main contract instance
        console.log(address(game));
        proxy = new Proxy(); 
        _game = new UpgradedGame();
        console.log(address(_game));
        me = vm.addr(0x3);
        user = vm.addr(0x4);
        vm.deal(address(me), 5 ether);
    }

    function test_Proxy() public {
        vm.prank(address(user));   // checking is non-owner address can call the upgradeTo() or not
        vm.expectRevert();
        proxy.upgradeTo(address(_game));
        vm.startPrank(address(me));
        game.initialize("uri");
        assertEq(game.owner(), address(me));
        proxy.initialize(address(_game));    // initializing with new contract address
        proxy.upgradeTo(address(_game));    // upgrading the old contract with new contract address
        assertEq(_game.monsterId(), 0);  // calling old contract's function with new implemented address, and congratulayions, it is working
    }
}

contract UpgradedGame is Game {
    function grettings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
