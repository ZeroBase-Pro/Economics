// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
 
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";
 

/// @title ZEROBASE Token Contract
/// @notice This contract implements a LayerZero-compatible cross-chain OFT token named "ZEROBASE Token" (ZBT)
/// @dev Inherits from LayerZero's OFT contract and OpenZeppelin's Ownable contract
/// @custom:security-contact steam@zerobase.pro
contract ZEROBASE is OFT {
    /// @notice The initial total supply of the token: 1,000,000,000 tokens with 18 decimals
    uint256 public constant INITIAL_SUPPLY = 1_000_000_000 * 10 ** 18;

    /// @notice Constructor that initializes the ZEROBASE token
    /// @dev Mints the initial supply to the receiver and sets up LayerZero endpoint and owner
    /// @param _lzEndpoint The address of the LayerZero endpoint contract on the current chain
    /// @param _owner The address that will be set as the owner of the contract
    /// @param _receiver The address that will receive the initial supply of the tokens
    constructor(
        address _lzEndpoint,
        address _owner,
        address _receiver
    ) OFT("ZEROBASE Token", "ZBT", _lzEndpoint, _owner) Ownable(_owner) {
        _mint(_receiver, INITIAL_SUPPLY);
    }
}
