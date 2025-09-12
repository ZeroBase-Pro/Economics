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

        // ========== BSC Testnet ==========
        ZEROBASE bscContract = ZEROBASE(BSC_CONTRACT);
        bscContract.setPeer(ETH_CHAIN_ID, bytes32(uint256(uint160(ETH_CONTRACT))));
        bscContract.setPeer(BASE_CHAIN_ID, bytes32(uint256(uint160(BASE_CONTRACT))));
        console2.log("Set ETH and BASE as peer on BSC Testnet");

        vm.stopBroadcast();
    }
}
//forge script script/SetTrustedRemote-BSC-ETHBASE.s.sol:SetTrustedRemoteScript --rpc-url $BSC_RPC_URL_MAIN --broadcast