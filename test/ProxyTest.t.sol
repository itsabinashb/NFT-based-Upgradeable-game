//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/Proxy.sol";

contract ProxyTest is Test {
    Proxy proxy;
    Game game;
    address me;
    UpgradedGame _game;

    function setUp() public {
        game = new Game();
        console.log("address of game", address(game));
        proxy = Proxy(address(game));
        console.log("address of proxy", address(proxy));
        _game = new UpgradedGame();
        me = vm.addr(0x1);
        vm.deal(address(me), 5 ether);
    }

    function test_proxy() public {
        vm.startPrank(address(me));
        game.initialize("uri");
        vm.expectRevert();
        game.initialize("uri");

        game.upgradeTo(address(_game));
        game.initialize("tokenUri");
    }
}

contract UpgradedGame is Game {
    function grettings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
