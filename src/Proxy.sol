//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Proxy is UUPSUpgradeable {
    constructor(address implementation) {
        _setImplementation(implementation);
    }

    // Inherited from ERC1967UpgradeUpgradeable
    function _setImplementation(address newImplementation) private  override {
        require(
            AddressUpgradeable.isContract(newImplementation),
            "ERC1967: new implementation is not a contract"
        );
        StorageSlotUpgradeable
            .getAddressSlot(_IMPLEMENTATION_SLOT)
            .value = newImplementation;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal virtual override {}
}

// https://sepolia.etherscan.io/address/0xe82b259dd65059be38828334200c194d73aa10b8

// The first contract is a simple wrapper or "proxy" which users interact with directly and is in charge of forwarding transactions to and from the second contract, which contains the logic.
