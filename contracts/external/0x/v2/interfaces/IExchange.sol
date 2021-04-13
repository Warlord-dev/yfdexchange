pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./IExchangeCore.sol";
import "./IMatchOrders.sol";
import "./ISignatureValidator.sol";
import "./ITransactions.sol";
import "./IAssetProxyDispatcher.sol";
import "./IWrapperFunctions.sol";


// solhint-disable no-empty-blocks
abstract contract IExchange is
    IExchangeCore,
    IMatchOrders,
    ISignatureValidator,
    ITransactions,
    IAssetProxyDispatcher,
    IWrapperFunctions
{}
