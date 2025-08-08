// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
 
contract SetTrustedRemoteScript is Script {
    address ARB_CONTRACT = vm.envAddress('ARB_CONTRACT_MAIN');
    address BSC_CONTRACT = vm.envAddress('BSC_CONTRACT_MAIN');
    
    // LayerZero Chain IDs
    uint32 constant ARB_CHAIN_ID = 30110; // ETH Sepolia
    uint32 constant BSC_CHAIN_ID = 30102; // BSC Testnet

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY_MAIN");
        vm.startBroadcast(privateKey);

        // ========== BSC Testnet ==========
        ZEROBASE bscContract = ZEROBASE(BSC_CONTRACT);
        bscContract.setPeer(ARB_CHAIN_ID, bytes32(uint256(uint160(ARB_CONTRACT))));
        console2.log("Set ETH as peer on BSC Testnet");

        vm.stopBroadcast();
    }
}
//forge script script/SetTrustedRemote-BSC.s.sol:SetTrustedRemoteScript --rpc-url $BSC_RPC_URL --broadcast