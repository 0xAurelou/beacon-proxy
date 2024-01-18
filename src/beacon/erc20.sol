// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {ERC20Upgradeable} from "openzeppelin-upgradeable-contracts/token/ERC20/ERC20Upgradeable.sol";

contract Erc20 is ERC20Upgradeable {
    function initialize(
        string memory name,
        string memory symbol
    ) external initializer {
        __ERC20_init(name, symbol);
    }
}
