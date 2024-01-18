// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {ERC20Upgradeable} from "openzeppelin-upgradeable-contracts/token/ERC20/ERC20Upgradeable.sol";
import {UUPSUpgradeable} from "openzeppelin-upgradeable-contracts/proxy/utils/UUPSUpgradeable.sol";

contract PocProxy is UUPSUpgradeable, ERC20Upgradeable {
    // keccak256(abi.encode(uint256(keccak256("PocProxy:Storage:V0")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant POC_PROXY_STORAGE_SLOT_V0 =
        0x16c9df44581e907e6b2370ff2d47dd17c6199f47024750591f3709a54554d200;

    struct PocProxyStorage {
        address implementation;
        string version;
    }

    constructor() {
        _disableInitializers();
    }

    function initialize(
        string memory name,
        string memory symbol,
        string calldata version_
    ) external initializer {
        __ERC20_init(name, symbol);
        setVersion(version_);
    }

    function getStorage() internal pure returns (PocProxyStorage storage s) {
        assembly {
            s.slot := POC_PROXY_STORAGE_SLOT_V0
        }
    }

    function setImplementation(address implementation_) public {
        getStorage().implementation = implementation_;
    }

    function setVersion(string calldata version_) public {
        getStorage().version = version_;
    }

    function getImplementation() public view returns (address) {
        return getStorage().implementation;
    }

    function getVersion() public view returns (string memory) {
        return getStorage().version;
    }

    function _authorizeUpgrade(address newImplementation) internal override {}
}
