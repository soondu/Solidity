// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex4_15 {
    uint a = 3;
    function myFun() public pure returns(uint){
        a = 4; //오류
        return a; //오류
    }
}