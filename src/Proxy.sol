//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract Proxy is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    address implemented;

    function initialize(address _newImplementation) public initializer {
        __UUPSUpgradeable_init();
        __Ownable_init();
        implemented = _newImplementation;
    }

    
    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}

    function getImplementedAddress() public view returns (address) {
        return implemented;
    }
}

// https://sepolia.etherscan.io/address/0x6f791bcc8192a8a039bdc79960b15b92e91117ec