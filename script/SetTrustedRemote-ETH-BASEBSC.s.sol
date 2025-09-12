// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
 
contract SetTrustedRemoteScript is Script {
    address ETH_CONTRACT = vm.envAddress('ETH_CONTRACT_MAIN');
    address BSC_CONTRACT = vm.envAddress('BSC_CONTRACT_MAIN');
    address BASE_CONTRACT = vm.envAddress('BASE_CONTRACT_MAIN');
    
    // LayerZero Chain IDs
    uint32 constant ETH_CHAIN_ID = 30101; // ETH
    uint32 constant BSC_CHAIN_ID = 30102; // BSC
    uint32 constant BASE_CHAIN_ID = 30184; // BASE

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        // ========== Sepolia ==========
        ZEROBASE ethContract = ZEROBASE(ETH_CONTRACT);
        ethContract.setPeer(BSC_CHAIN_ID, bytes32(uint256(uint160(BSC_CONTRACT))));
        ethContract.setPeer(BASE_CHAIN_ID, bytes32(uint256(uint160(BASE_CONTRACT))));
        console2.log("Set BSC and BASE as peer on ETH");
        vm.stopBroadcast();
    }
}