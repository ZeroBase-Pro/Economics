// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
 
contract SetTrustedRemoteScript is Script {
    address ARB_CONTRACT = vm.envAddress('ARB_CONTRACT_MAIN');
    address BSC_CONTRACT = vm.envAddress('BSC_CONTRACT_MAIN');
    
    // LayerZero Chain IDs
    uint32 constant ARB_CHAIN_ID = 30110; // Arbitrum
    uint32 constant BSC_CHAIN_ID = 30102; // BSC

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY_MAIN");
        vm.startBroadcast(privateKey);

        // ========== BSC Testnet ==========
        ZEROBASE bscContract = ZEROBASE(ARB_CONTRACT);
        bscContract.setPeer(BSC_CHAIN_ID, bytes32(uint256(uint160(BSC_CONTRACT))));
        console2.log("Set BSC as peer on ARB");

        vm.stopBroadcast();
    }
}
//forge script script/SetTrustedRemote-BSC.s.sol:SetTrustedRemoteScript --rpc-url $BSC_RPC_URL --broadcast
