// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
import {Factory} from "../src/Factory.sol";
 
contract ZeroBaseScript is Script {
    address constant LAYERZERO_ENDPOINT = 0x1a44076050125825900e736c501f859c50fE728c;
    address owner;
    Factory fac;

    function run() public {
        // Setup
        uint256 privateKey = vm.envUint("PRIVATE_KEY_MAIN");//Main
        vm.startBroadcast(privateKey);

        fac = new Factory();
        console2.log("Factory deployed at:", address(fac));

        owner = vm.addr(privateKey);

        bytes32 salt_ = bytes32(0x000000000000000000000000000000000000000000000000000000000000c0de);
        bytes memory code = abi.encodePacked(
            type(ZEROBASE).creationCode, 
            abi.encode(owner),
            abi.encode(uint(block.timestamp + 10000))
        );
        // Deploy
        address zeroBase = fac.deploy(salt_, code);
        console2.log("ZEROBASE deployed at:", address(zeroBase));

        vm.stopBroadcast();
    }
}
