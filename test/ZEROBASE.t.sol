// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test} from "forge-std/Test.sol";
import {ZEROBASE} from "../src/ZEROBASE.sol";

contract A{}

contract ZEROBASETest is Test {
    ZEROBASE token;
    address lzEndpoint = 0x6EDCE65403992e310A62460808c4b910D972f10f;
    address owner = address(0x2222);
    address receiver = address(0x3333);

    function setUp() public {
        vm.createSelectFork(vm.envString("SEPOLIA_RPC_URL"));
        token = new ZEROBASE(lzEndpoint, owner, receiver);
    }

    function testNameAndSymbol() public view {
        assertEq(token.name(), "ZEROBASE Token");
        assertEq(token.symbol(), "ZBT");
    }

    function testInitialSupplyMintedToReceiver() public view {
        uint256 expectedSupply = 1_000_000_000 * 10 ** 18;
        assertEq(token.totalSupply(), expectedSupply);
        assertEq(token.balanceOf(receiver), expectedSupply);
    }

    function testOwnerIsCorrect() public view {
        assertEq(token.owner(), owner);
    }

    function testTransferWorks() public {
        vm.prank(receiver);
        require(token.transfer(address(0x4444), 1000 ether));
        assertEq(token.balanceOf(address(0x4444)), 1000 ether);
    }

    function testOnlyOwnerCanDoOwnerStuff() public {
        vm.startPrank(address(0x9999));
        vm.expectRevert();
        token.transferOwnership(address(0x1234));
        vm.stopPrank();

        vm.prank(owner);
        token.transferOwnership(address(0x1234));
        assertEq(token.owner(), address(0x1234));
    }
}
