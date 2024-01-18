// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract PocProxy {
    bytes32 public constant POC_PROXY_STORAGE_SLOT_V0 =
        keccak256("poc.proxy.storage");

    struct PocProxyStorage {
        address implementation;
        string version;
    }
}
