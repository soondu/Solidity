// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex6_2{
    function runAssert(bool _bool) public pure returns(bool){
        assert(_bool);
        return _bool;
    }

    function divisionByZero(uint num1, uint num2) public pure returns(uint){
        return num1/num2;
    } // num2가 0일때 내부 오류 (assert)발생
}
