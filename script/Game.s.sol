//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../src/Game.sol";

contract MyScript is Script {

    /**
     * By default scripts are runs by calling run(), this is the entry point
     */
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey); // This cheatcode records calls and contract creations made by our main script contract
        Game game = new Game(); // We created our NFT contract
        vm.stopBroadcast();
    }
}

// 0x586e0f6ca6c861a4e7ac6e4c32e1fa030b297eaf