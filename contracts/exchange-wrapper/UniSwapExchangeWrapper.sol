pragma solidity ^0.6.0;

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol';
import '@uniswap/lib/contracts/libraries/Babylonian.sol';
import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import '../lib/UniswapV2LiquidityMathLibrary.sol';
import '../interfaces/IERC20.sol';
import '../interfaces/IUniswapV2Router02.sol';
import '../lib/SafeMath.sol';
import '../lib/UniswapV2Library.sol';

import { ExchangeWrapper } from "../interfaces/ExchangeWrapper.sol";
import { TokenInteract } from "../lib/TokenInteract.sol";

contract UniswapExchangeWrapper is
    ExchangeWrapper
{
    using SafeMath for uint256;
    using TokenInteract for address;

    IUniswapV2Router02 public immutable router;
    address public immutable factory;

    constructor(address factory_, IUniswapV2Router02 router_) public {
        factory = factory_;
        router = router_;
    }


    struct Trade {
        int128 fromId;
        int128 toId;
        uint256 fromAmount;
    }

    // ============ Public Functions ============

    function exchange(
        address /* tradeOriginator */,
        address receiver,
        address makerToken,
        address takerToken,
        uint256 requestedFillAmount,
        bytes calldata /* orderData */
    )
        override
        external
        returns (uint256)
    {
        TransferHelper.safeTransferFrom(takerToken, msg.sender, address(this), requestedFillAmount);
        TransferHelper.safeApprove(takerToken, address(router), requestedFillAmount);

        address[] memory path = new address[](2);
        path[0] = takerToken;
        path[1] = makerToken;

        router.swapExactTokensForTokens(
            requestedFillAmount,
            0, 
            path,
            receiver,
            block.timestamp
        );

        uint256 toAmount = makerToken.balanceOf(address(this));

        makerToken.approve(receiver, toAmount);

        return toAmount;
    }

    function getExchangeCost(
        address /* makerToken */,
        address /* takerToken */,
        uint256 /* desiredMakerToken */,
        bytes calldata /* orderData */
    )
        override
        external
        view
        returns (uint256)
    {
        revert("getExchangeCost not implemented");
    }
}
