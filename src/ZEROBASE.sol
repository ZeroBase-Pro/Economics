// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;
 
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import { OFT } from "@layerzerolabs/oft-evm/contracts/OFT.sol";

 

/// @title ZEROBASE Token Contract
/// @notice This contract implements a LayerZero-compatible cross-chain OFT token named "ZEROBASE Token" (ZBT)
/// @dev Inherits from LayerZero's OFT contract and OpenZeppelin's Ownable contract
/// @custom:security-contact steam@zerobase.pro
contract ZEROBASE is OFT {
    /// @notice The initial total supply of the token: 1,000,000,000 tokens with 18 decimals(BSC)

    uint256 public immutable SUPPLY_CAP;
    address public constant LZ_POINT = 0x1a44076050125825900e736c501f859c50fE728c;
    address public constant MULTISIG = address(0xffff);
    uint256 public supplyAllChains;
    uint public transferAllowedTime;
    uint public ETA;

    mapping(address => bool) public isWhitelisted;
    mapping(address => bool) public isMinter;

    event WhitelistUpdated(address indexed _address, bool _value);
    event MinterUpdated(address indexed _address, bool _value);
    event TransferAllowedTimeUpdated(uint _new);

    /// @notice Constructor that initializes the ZEROBASE token
    /// @dev Mints the initial supply to the receiver and sets up LayerZero endpoint and owner
    /// @param _owner The address that will be set as the owner of the contract

    constructor(
        address _owner,
        uint _newTimestamp
    ) OFT("ZEROBASE", "ZBT", LZ_POINT, _owner) Ownable(_owner) {
        isWhitelisted[_owner] = true;
        isMinter[_owner] = true;
        uint256 id;

        assembly {
            id := chainid()
        }

        if(id == 56){
            SUPPLY_CAP = 1_000_000_000 * 10 ** 18;
            uint mintAmount = SUPPLY_CAP * 90 / 100;
            _mint(_owner, mintAmount);
            supplyAllChains += mintAmount;
        }

        transferAllowedTime = _newTimestamp;
    }

    function _update(address from, address to, uint256 value) internal override {
        if(block.timestamp < transferAllowedTime){
            if (from == address(0)) require(isMinter[msg.sender]);
            else if (to == address(0)) revert();
            else require(isWhitelisted[msg.sender], "paused and not whitelisted");
        }
        super._update(from, to, value);
    }

    /// @notice Sets whether an address is whitelisted or not
    /// @dev Only callable by the multisig of the contract
    /// @param _address The address to set the whitelisted status for
    function setWhitelisted(address _address) external {
        require(msg.sender == MULTISIG);
        bool value = !isWhitelisted[_address];
        isWhitelisted[_address] = value;

        emit WhitelistUpdated(_address, value);
    }

    /// @notice Sets whether an address is a minter or not
    /// @dev Only callable by the owner of the contract
    /// @param _address The address to set the minter status for
    function setMinter(address _address) external onlyOwner {
        bool value = !isMinter[_address];
        isMinter[_address] = value;

        emit MinterUpdated(_address, value);
    }

    /// @notice Sets the transferAllowedTime
    /// @dev Only callable by the multisig of the contract]
    function setTransferAllowedTime(uint newTimestamp) external {
        require( msg.sender == MULTISIG);
        if (transferAllowedTime > block.timestamp && ETA == 0) {
            transferAllowedTime = newTimestamp;
        } else {
        if (ETA == 0) {
            ETA = transferAllowedTime + 1 days;
        }
        require(newTimestamp <= ETA);
        transferAllowedTime = newTimestamp;
    }
        emit TransferAllowedTimeUpdated(newTimestamp);
    }

    function mint(address _to, uint256 _amount) external {
        require(supplyAllChains + _amount <= SUPPLY_CAP);
        require(isMinter[msg.sender]);
        _mint(_to, _amount);
        supplyAllChains += _amount;
    }
}
