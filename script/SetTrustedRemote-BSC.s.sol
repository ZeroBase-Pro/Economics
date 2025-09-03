// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
 
contract SetTrustedRemoteScript is Script {
    address ETH_CONTRACT = vm.envAddress('ETH_CONTRACT');
    address BSC_CONTRACT = vm.envAddress('BSC_CONTRACT');
    
    // LayerZero Chain IDs
    uint32 constant ETH_CHAIN_ID = 40161; // ETH Sepolia
    uint32 constant BSC_CHAIN_ID = 40102; // BSC Testnet

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // ========== BSC Testnet ==========
        ZEROBASE bscContract = ZEROBASE(BSC_CONTRACT);
        bscContract.setPeer(ETH_CHAIN_ID, bytes32(uint256(uint160(ETH_CONTRACT))));
        console2.log("Set ETH as peer on BSC Testnet");

        vm.stopBroadcast();
    }
}
