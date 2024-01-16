// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "src/erc20.sol";

import "src/erc20Beacon.sol";

import "openzeppelin-contracts/proxy/beacon/BeaconProxy.sol";

contract Erc20Factory {
    event Erc20Created(address indexed erc20);

    mapping(bytes32 => address) public erc20s;
    Erc20Beacon public immutable beacon;

    constructor(address _logic) {
        beacon = Erc20Beacon(_logic);
    }

    function createErc20(
        string memory name,
        string memory symbol
    ) public returns (address) {
        BeaconProxy token = new BeaconProxy(
            address(beacon),
            abi.encodeWithSignature("initialize(string,string)", name, symbol)
        );
        erc20s[keccak256(abi.encodePacked(name, symbol))] = address(token);
        emit Erc20Created(address(token));
        return address(token);
    }

    function getErc20(
        string memory name,
        string memory symbol
    ) public view returns (address) {
        return erc20s[keccak256(abi.encodePacked(name, symbol))];
    }

    function getBeaconAddress() public view returns (address) {
        return address(beacon);
    }

    function forwardCall(address target, bytes memory data) public {
        (bool success, bytes memory result) = target.call(data);
        require(success, string(result));
    }
}
