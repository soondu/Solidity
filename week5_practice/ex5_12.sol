// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// constructor
contract Ex5_12 {
    uint public immutable num;

    //배포할 때 변수에 특정한 값을 넣어줄 때 사용
    constructor(uint _num){
        num=_num;
    }

    // 변경 불가함!
    // function change() public pure returns(uint){
    //     num=10;
    // }
}