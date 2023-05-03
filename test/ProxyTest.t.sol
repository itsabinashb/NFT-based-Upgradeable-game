//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/MainProxy.sol";

contract ProxyTest is Test {
    MainProxy proxy;
    Game game;
    address me;
    UpgradedGame _game;

    function setUp() public {
        me = vm.addr(0x1);
        game = new Game();
        proxy = new MainProxy(address(game), abi.encodeWithSignature("initialize()", 0.001 ether));
        _game = new UpgradedGame();
    }

    function test_proxy() public {
        vm.startPrank(address(me));
       // assertEq(proxy.monsterId(), 0);
        //proxy.generateMonster{0.01 ether}();
        //proxy.tokenId();
    }
}

contract UpgradedGame is Game {
    function grettings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
