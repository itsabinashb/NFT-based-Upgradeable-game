// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "forge-std/Script.sol";
import "../src/Proxy.sol";

contract ProxyScript is Script {
    function run() external returns(address _address){
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        Proxy proxy = new Proxy();
        _address = address(proxy);
        vm.stopBroadcast();
        return _address;
    }
}