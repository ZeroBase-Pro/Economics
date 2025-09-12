// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import {ZEROBASE} from "./ZeroBase.sol";

contract Factory{
    function deploy(bytes32 salt, bytes memory code) external returns(address){
        address addr;
      
        assembly {
          addr := create2(0, add(code, 0x20), mload(code), salt)
        }
        return addr;
    }
}