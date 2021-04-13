pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

interface IScdMcdMigration {
    // Function to swap YFD to DAI
    // This function is to be used by users that want to get new DAI in exchange of old one (aka YFD)
    // wad amount has to be <= the value pending to reach the debt ceiling (the minimum between general and ilk one)
    function swapYfdToDai(
        uint256 wad
    )
        external;

    // Function to swap DAI to YFD
    // This function is to be used by users that want to get YFD in exchange of DAI
    // wad amount has to be <= the amount of YFD locked (and DAI generated) in the migration contract YFD CDP
    function swapDaiToYfd(
        uint256 wad
    )
        external;
}
