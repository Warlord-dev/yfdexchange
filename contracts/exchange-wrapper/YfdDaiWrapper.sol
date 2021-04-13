// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { IScdMcdMigration } from "../external/Maker/Other/IScdMcdMigration.sol";
import { ExchangeWrapper } from "../interfaces/ExchangeWrapper.sol";
import { AdvancedTokenInteract } from "../lib/AdvancedTokenInteract.sol";
import { TokenInteract } from "../lib/TokenInteract.sol";

contract YfdDaiExchangeWrapper is
    ExchangeWrapper
{
    using AdvancedTokenInteract for address;
    using TokenInteract for address;

    // ============ Storage ============

    address public MIGRATION_CONTRACT;

    address public YFD;

    address public DAI;

    // ============ Constructor ============

    constructor(
        address migrationContract,
        address yfd,
        address dai
    )
        public
    {
        MIGRATION_CONTRACT = migrationContract;
        YFD = yfd;
        DAI = dai;

        yfd.approve(migrationContract, uint256(-1));
        dai.approve(migrationContract, uint256(-1));
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
        external
        override
        returns (uint256)
    {
        address yfd = YFD;
        address dai = DAI;

        bool tokensAreValid =
            (takerToken == yfd && makerToken == dai)
            || (takerToken == dai && makerToken == yfd);

        require(
            tokensAreValid,
            "YfdDaiExchangeWrapper#exchange: Invalid tokens"
        );

        IScdMcdMigration migration = IScdMcdMigration(MIGRATION_CONTRACT);

        if (takerToken == yfd) {
            migration.swapYfdToDai(requestedFillAmount);
        } else {
            migration.swapDaiToYfd(requestedFillAmount);
        }

        // ensure swap occurred properly
        assert(makerToken.balanceOf(address(this)) >= requestedFillAmount);

        // set allowance for the receiver
        makerToken.ensureAllowance(receiver, requestedFillAmount);

        return requestedFillAmount;
    }

    function getExchangeCost(
        address /* makerToken */,
        address /* takerToken */,
        uint256 desiredMakerToken,
        bytes calldata /* orderData */
    )
        external
        override
        view
        returns (uint256)
    {
        return desiredMakerToken;
    }
}
