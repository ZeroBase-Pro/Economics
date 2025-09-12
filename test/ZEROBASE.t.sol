// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console2} from "forge-std/Test.sol";
import {ZEROBASE} from "../src/ZEROBASE.sol";

contract A{}

contract ZEROBASETest is Test {
    ZEROBASE token;
    address lzEndpoint = 0x1a44076050125825900e736c501f859c50fE728c;
    address owner = address(0x2222);

    function setUp() public {
        vm.createSelectFork(vm.envString("BSC_RPC_URL_MAIN"));
        token = new ZEROBASE(owner);
    }

    function testNameAndSymbol() public view {
        assertEq(token.name(), "ZEROBASE");
        assertEq(token.symbol(), "ZBT");
    }

    function testInitialSupplyMintedToReceiver() public view {
        uint256 expectedSupply = 1_000_000_000 * 10 ** 18;
        expectedSupply = expectedSupply * 90 / 100;
        assertEq(token.totalSupply(), expectedSupply);
        assertEq(token.balanceOf(owner), expectedSupply);
    }

    function testOwnerIsCorrect() public view {
        assertEq(token.owner(), owner);
    }

    function testTransferWorks() public {
        vm.prank(owner);
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

    function testOwnerCanMint() public {
        uint256 amount = 1000 ether;
        vm.prank(owner);
        token.mint(owner, amount);
        assertEq(token.balanceOf(owner), amount+(token.SUPPLY_CAP()*9/10));   
        
        vm.prank(address(0x4444));
        vm.expectRevert();
        token.mint(owner, amount);
    }

    function testAddAddress() public {
        vm.prank(token.MULTISIG());
        token.pause();
        vm.startPrank(address(0x4444));
        vm.expectRevert();
        token.mint(address(0x4444), 1000 ether);
        vm.expectRevert();
        token.transfer(address(0x5555), 1000 ether);
        vm.stopPrank();

        vm.prank(owner);
        token.setMinter(address(0x4444));
        vm.prank(token.MULTISIG());
        token.setWhitelisted(address(0x4444));
        assertEq(token.isWhitelisted(address(0x4444)), true);
        assertEq(token.isMinter(address(0x4444)), true);

        vm.startPrank(address(0x4444));
        token.mint(address(0x4444), 1000 ether);
        assertEq(token.balanceOf(address(0x4444)), 1000 ether);
        token.transfer(address(0x5555), 1000 ether);
        assertEq(token.balanceOf(address(0x5555)), 1000 ether);
    }

    function testTransferPaused() public {
        vm.prank(token.MULTISIG());
        token.pause();
        vm.startPrank(owner);
        token.mint(owner, 1000 ether);
        token.mint(address(0x3333), 1000 ether);
        // vm.expectRevert();
        token.transfer(address(0x4444), 1000 ether);
        assertEq(token.balanceOf(address(0x4444)), 1000 ether);
        vm.stopPrank();

        vm.startPrank(address(0x3333));
        vm.expectRevert();
        token.transfer(address(0x4444), 1000 ether);
        assertEq(token.balanceOf(address(0x4444)), 1000 ether);
        vm.stopPrank();

        vm.prank(token.MULTISIG());
        token.pause();
        vm.startPrank(address(0x3333));
        token.transfer(address(0x4444), 1000 ether);
        assertEq(token.balanceOf(address(0x4444)), 2000 ether);
        vm.stopPrank();
    }

    function testMintWhenPaused() public {
        vm.prank(token.MULTISIG());
        token.pause();
        vm.prank(owner);
        token.setMinter(address(0x4444));
        vm.prank(address(0x4444));
        token.mint(owner, 1000 ether);
    }

    function testCreationCode() public pure {
        address deployer = 0x69fFfc00570776e19B8719D5b36787A2cF70861A;
        bytes memory bytecodeWithArgs = abi.encodePacked(
        type(ZEROBASE).creationCode, 
        abi.encode(deployer)
        );
        console2.logBytes(bytecodeWithArgs);
    }
}
