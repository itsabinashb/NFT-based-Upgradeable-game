//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/Proxy.sol";

contract ProxyTest is Test {
    Game game;
    UpgradedGame _game;
    Proxy proxy;
    address me;
    address user;

    function setUp() public {
        game = new UpgradedGame();
        proxy = new Proxy();
        _game = new UpgradedGame();
        me = vm.addr(0x3);
        user = vm.addr(0x4);
        vm.deal(address(me), 5 ether);
    }

    function test_Proxy() public {
        vm.prank(address(user));
        vm.expectRevert();
        proxy.upgradeTo(address(_game));
        vm.stopPrank();
        vm.startPrank(address(me));
        game.initialize("uri");
        assertEq(game.owner(), address(me));
        proxy.initialize(address(_game));
        proxy.upgradeTo(address(_game));
    }
}

contract UpgradedGame is Game {
    function grettings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
