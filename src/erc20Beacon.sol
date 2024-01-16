// SPDX-License-Identifier: MIT License
pragma solidity 0.8.19;

import {ERC20} from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import {UpgradeableBeacon} from "openzeppelin-contracts/proxy/beacon/UpgradeableBeacon.sol";

contract Erc20Beacon {
    UpgradeableBeacon public immutable beacon;

    address public blueprint;

    address public logic = address(0x0);

    constructor(address _logic) {
        beacon = new UpgradeableBeacon(_logic);
        logic = _logic;
    }

    function upgradeTo(address _logic) external {
        beacon.upgradeTo(_logic);
        logic = _logic;
    }

    function implementation() external view returns (address) {
        return beacon.implementation();
    }
}
