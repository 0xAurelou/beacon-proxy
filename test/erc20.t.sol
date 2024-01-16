// SPDX-License-Identifier: MIT License

pragma solidity 0.8.19;

import "src/erc20.sol";
import "src/erc20Beacon.sol";
import "src/erc20Factory.sol";
import "src/erc201.sol";

import "forge-std/Test.sol";

contract Erc20Test is Test {
    Erc20Factory public erc20Factory;
    Erc20Beacon public erc20Beacon;
    Erc201 public erc201;
    Erc20 public erc20;

    function setUp() public {
        erc20 = new Erc20();
        erc20.initialize("Test 0", "Test 0");
        // deploy erc20Beacon
        erc20Beacon = new Erc20Beacon(address(erc20));
        // deploy erc20Factory
        erc20Factory = new Erc20Factory(address(erc20Beacon));
        // deploy erc20
    }

    function testAddressNotZero() public {
        assertTrue(
            address(erc20Factory) != address(0x0),
            "address should not be zero"
        );

        assertTrue(erc20Beacon.implementation() != address(0));
        assertTrue(erc20Beacon.implementation() == address(erc20));
    }

    function testCallImplementation() public {
        assertTrue(
            address(erc20Factory.beacon()) == address(erc20Beacon),
            "address should be equal"
        );
    }

    function testUpgrade() public {
        erc201 = new Erc201();
        erc201.initialize("Test 1", "Test 1");
        erc20Beacon.upgradeTo(address(erc201));

        assertTrue(erc20Beacon.implementation() == address(erc201));
    }

    function testCreateErc20AndUpgrade() public {
        erc20Factory.createErc20("Test 1", "Test 1");
        assertTrue(
            erc20Factory.getErc20("Test 1", "Test 1") != address(0),
            "address should not be zero"
        );
        erc20Factory.createErc20("Test 2", "Test 2");
        assertTrue(
            erc20Factory.getErc20("Test 2", "Test 2") != address(0),
            "address should not be zero"
        );

        erc201 = new Erc201();
        erc201.initialize("Test 1", "Test 1");
        erc20Beacon.upgradeTo(address(erc201));

        assertTrue(erc201.getCount() == 0, "should be 0");

        erc20Factory.forwardCall(
            address(erc201),
            abi.encodeWithSignature("increment(uint256)", 1)
        );

        address secondToken = erc20Factory.getErc20("Test 2", "Test 2");

        erc20Factory.forwardCall(
            secondToken,
            abi.encodeWithSignature("increment(uint256)", 1)
        );

        (bool rtn, bytes memory data) = address(secondToken).call(
            abi.encodeWithSignature("getCount()")
        );

        assertTrue(rtn, "should be true");
        assertTrue(abi.decode(data, (uint256)) == 1, "should be 1");

        assertTrue(erc201.getCount() == 1, "should be 1");

        assertTrue(erc20Beacon.implementation() == address(erc201));
    }
}
