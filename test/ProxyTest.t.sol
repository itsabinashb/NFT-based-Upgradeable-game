//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Game.sol";
import "../src/Proxy.sol";

contract ProxyTest is Test {
    Game game; // main contract address
    UpgradedGame _game; // upgraded contract address
    Proxy proxy; // proxy contract address
    address me;
    address user;

    function setUp() public {
        game = new Game(); // new main contract instance
        console.log("address of before implementation",address(game));
        proxy = new Proxy();
        _game = new UpgradedGame();
        console.log("address of after implementation",address(_game));
        me = vm.addr(0x3);
        user = vm.addr(0x4);
        vm.deal(address(me), 5 ether);
        vm.deal(address(user), 5 ether);
    }

    function test_Proxy() public {
        vm.startPrank(address(user)); // checking is non-owner address can call the upgradeTo() or not
        vm.expectRevert();
        proxy.upgradeTo(address(_game));
        game.initialize("uri");
        game.generateMonster{value: 0.01 ether}();
        assertEq(game.monsterId(), 1);
        vm.stopPrank();
        vm.startPrank(address(me));
        proxy.initialize(address(_game));
        proxy.upgradeTo(address(_game));
        _game.initialize("tokenUri");
        assertEq(_game.baseUri(), "tokenUri");
        _game.generateMonster{value: 0.01 ether}();
        assertEq(_game.monsterId(),1);
       
    }
}

contract UpgradedGame is Game {
    function grettings() public pure returns (string memory) {
        return "You are doing well!";
    }
}
