// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
 
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";
contract ZEROBASE is OFT {
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;
    constructor(
        address _lzEndpoint,
        address _owner,
        address _receiver
    ) OFT("ZEROBASE Token", "ZBT", _lzEndpoint, _owner) Ownable(_owner) {
        _mint(_receiver, INITIAL_SUPPLY);
    }
}
