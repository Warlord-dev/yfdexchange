pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import { ISimpleMarketV1 } from "./ISimpleMarketV1.sol";


abstract contract IMatchingMarketV1 is ISimpleMarketV1 {

    // ============ Structs ================

    struct sortInfo {
        uint256 next;  //points to id of next higher offer
        uint256 prev;  //points to id of previous lower offer
        uint256 delb;  //the blocknumber where this entry was marked for delete
    }

    // ============ Storage ================

    uint64 public close_time;

    bool public stopped;

    bool public buyEnabled;

    bool public matchingEnabled;

    mapping(uint256 => sortInfo) public _rank;

    mapping(address => mapping(address => uint)) public _best;

    mapping(address => mapping(address => uint)) public _span;

    mapping(address => uint) public _dust;

    mapping(uint256 => uint) public _near;

    mapping(bytes32 => bool) public _menu;

    // ============ Functions ================

    function make(
        address  pay_gem,
        address  buy_gem,
        uint128  pay_amt,
        uint128  buy_amt
    )
        virtual
        override
        public
        returns (bytes32);

    function take(
        bytes32 id,
        uint128 maxTakeAmount
    )
        virtual
        override
        public;

    function kill(
        bytes32 id
    )
        virtual
        override
        public;

    function offer(
        uint256 pay_amt,
        address pay_gem,
        uint256 buy_amt,
        address buy_gem
    )
        public
        override
        virtual
        returns (uint);

    function offer(
        uint256 pay_amt,
        address pay_gem,
        uint256 buy_amt,
        address buy_gem,
        uint256 pos
    )
        public
        virtual
        returns (uint);

    function offer(
        uint256 pay_amt,
        address pay_gem,
        uint256 buy_amt,
        address buy_gem,
        uint256 pos,
        bool rounding
    )
        public
        virtual
        returns (uint);

    function buy(
        uint256 id,
        uint256 amount
    )
        public
        override
        virtual
        returns (bool);

    function cancel(
        uint256 id
    )
        public
        virtual
        override
        returns (bool success);

    function insert(
        uint256 id,
        uint256 pos
    )
        public
        virtual
        returns (bool);

    function del_rank(
        uint256 id
    )
        public
        virtual
        returns (bool);

    function sellAllAmount(
        address pay_gem,
        uint256 pay_amt,
        address buy_gem,
        uint256 min_fill_amount
    )
        public
        virtual
        returns (uint256 fill_amt);

    function buyAllAmount(
        address buy_gem,
        uint256 buy_amt,
        address pay_gem,
        uint256 max_fill_amount
    )
        public
        virtual
        returns (uint256 fill_amt);

    // ============ Constant Functions ================

    function isTokenPairWhitelisted(
        address baseToken,
        address quoteToken
    )
        public
        view
        virtual
        returns (bool);

    function getMinSell(
        address pay_gem
    )
        public
        view
        virtual
        returns (uint);

    function getBestOffer(
        address sell_gem,
        address buy_gem
    )
        public
        view
        virtual
        returns(uint);

    function getWorseOffer(
        uint256 id
    )
        public
        view
        virtual
        returns(uint);

    function getBetterOffer(
        uint256 id
    )
        public
        view
        virtual
        returns(uint);

    function getOfferCount(
        address sell_gem,
        address buy_gem
    )
        public
        view
        virtual
        returns(uint);

    function getFirstUnsortedOffer()
        public
        view
        virtual
        returns(uint);

    function getNextUnsortedOffer(
        uint256 id
    )
        public
        view
        virtual
        returns(uint);

    function isOfferSorted(
        uint256 id
    )
        public
        view
        virtual
        returns(bool);

    function getBuyAmount(
        address buy_gem,
        address pay_gem,
        uint256 pay_amt
    )
        public
        view
        virtual
        returns (uint256 fill_amt);

    function getPayAmount(
        address pay_gem,
        address buy_gem,
        uint256 buy_amt
    )
        public
        view
        virtual
        returns (uint256 fill_amt);

    function isClosed()
        public
        view
        virtual
        returns (bool closed);

    function getTime ()
        public
        view
        virtual
        returns (uint64);
}
