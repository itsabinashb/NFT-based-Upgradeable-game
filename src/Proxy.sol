//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";

contract Proxy is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    address implemented;

    function initialize(address _newImplementation) public initializer {
        __UUPSUpgradeable_init();
        implemented = _newImplementation;
    }

    function upgradeTo(
        address newImplementation
    ) external virtual override onlyOwner {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallUUPS(newImplementation, new bytes(0), false);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}

    function getImplementedAddress() public view returns (address) {
        return implemented;
    }
}

// https://sepolia.etherscan.io/address/0xebbf8e975cd8acaf343a3b002f37e84cdea3a68d
