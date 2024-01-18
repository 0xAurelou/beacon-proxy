// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract PocProxy {
    // keccak256(abi.encode(uint256(keccak256("PocProxy:Storage:V0")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 public constant POC_PROXY_STORAGE_SLOT_V0 =
        0x16c9df44581e907e6b2370ff2d47dd17c6199f47024750591f3709a54554d200;

    struct PocProxyStorage {
        address implementation;
        string version;
    }

    function getStorage() internal pure returns (PocProxyStorage storage s) {
        assembly {
            s.slot := POC_PROXY_STORAGE_SLOT_V0
        }
    }

    function setImplementation(address implementation_) public {
        getStorage().implementation = implementation_;
    }

    function setVersion() public {
        getStorage().version = "V0";
    }

    function getImplementation() public view returns (address) {
        return getStorage().implementation;
    }

    function getVersion() public view returns (string memory) {
        return getStorage().version;
    }
}
