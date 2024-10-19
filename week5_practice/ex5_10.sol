// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 이벤트 발생
contract Ex5_10 {
    event MyFunction(uint result, string name);

    function add(uint _a, uint _b) public { // pure,view 됨
        uint total = _a + _b;
        emit MyFunction(total, "add"); // emit 꼭 해줘야함
    }
    function mul(uint _a, uint _b) public{
        uint total=_a*_b;
        emit MyFunction(total, "mul");
    }

}