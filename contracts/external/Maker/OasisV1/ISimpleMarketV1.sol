pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;


abstract contract ISimpleMarketV1 {

    // ============ Structs ================

    struct OfferInfo {
        uint256     pay_amt;
        address  pay_gem;
        uint256     buy_amt;
        address  buy_gem;
        address  owner;
        uint64   timestamp;
    }

    // ============ Storage ================

    uint256 public last_offer_id;

    mapping (uint256 => OfferInfo) public offers;

    constructor() public {}
    // ============ Functions ================

    function isActive(
        uint256 id
    )
        virtual
        public
        view
        returns (bool active );

    function getOwner(
        uint256 id
    )
        public
        virtual
        view
        returns (address owner);

    function getOffer(
        uint256 id
    )
        public
        view
        virtual
        returns (uint, address, uint, address);

    function bump(
        bytes32 id_
    )
        virtual
        public;

    function buy(
        uint256 id,
        uint256 quantity
    )
        virtual
        public
        returns (bool);

    function cancel(
        uint256 id
    )
        virtual
        public
        returns (bool success);

    function kill(
        bytes32 id
    )
        virtual
        public;

    function make(
        address  pay_gem,
        address  buy_gem,
        uint128  pay_amt,
        uint128  buy_amt
    )
        virtual
        public
        returns (bytes32 id);


    function offer(
        uint256 pay_amt,
        address pay_gem,
        uint256 buy_amt,
        address buy_gem
    )
        virtual
        public
        returns (uint256 id);

    function take(
        bytes32 id,
        uint128 maxTakeAmount
    )
        virtual
        public;
}
