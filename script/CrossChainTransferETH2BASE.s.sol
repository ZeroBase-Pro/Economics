// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
 
import {Script} from "../lib/forge-std/src/Script.sol";
import {console2} from "../lib/forge-std/src/console2.sol";
import {ZEROBASE} from "../src/ZeroBase.sol";
import {SendParam, MessagingFee} from "@layerzerolabs/oft-evm/contracts/interfaces/IOFT.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";
 
contract CrossChainTransferScript is Script {
    using OptionsBuilder for bytes;
    address ETH_CONTRACT = vm.envAddress('ETH_CONTRACT_MAIN'); // ETH
    
    // LayerZero Chain IDs
    uint32 constant BASE_CHAIN_ID = 30184; // BASE
    
    address TARGET_ADDRESS = vm.envAddress('ADDRESS');

    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY_MAIN");
        vm.startBroadcast(privateKey);

        ZEROBASE ethContract = ZEROBASE(ETH_CONTRACT);
        
        uint256 amount = 800 * 1e18; // 800 ZBT

        bytes memory extraOptions = OptionsBuilder.newOptions().addExecutorLzReceiveOption(200_000, 0);

        SendParam memory sendParam = SendParam({
            dstEid: BASE_CHAIN_ID,
            to: bytes32(uint256(uint160(TARGET_ADDRESS))),
            amountLD: amount,
            minAmountLD: amount * 95 / 100,
            extraOptions: extraOptions,
            composeMsg: "",
            oftCmd: ""
        });
        
        MessagingFee memory estimatedFee = ethContract.quoteSend(sendParam, false);
        console2.log("Estimated native fee:", estimatedFee.nativeFee);
        console2.log("Estimated lzToken fee:", estimatedFee.lzTokenFee);
        
        
        ethContract.send{value: estimatedFee.nativeFee}(
            sendParam,
            estimatedFee,
            payable(vm.addr(privateKey)) // refund address
        );
        
        console2.log("Cross-chain transfer initiated!");

        vm.stopBroadcast();
    }
}