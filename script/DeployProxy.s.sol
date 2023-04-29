// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Script.sol";
import "../foundry-upgrades/src/ProxyTester.sol";
import "../foundry-upgrades/src/utils/DeployProxy.sol";

contract DeployProxy is Script, ProxyTester, DeployProxy {
    address _address;
    function run() {
        setType("uups");
        _address = deploy(0xc79F6DbB9FfAEC3f28eDEACB1Fe921f3c9B3eC25);
    }
}
