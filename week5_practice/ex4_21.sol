// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_21 {
    uint public pub = 1;
    uint private pri = 2;
    uint internal inter = 3; 
    //uint external ext = 4; // external은 변수 적용 불가
    function funPub() public view returns(uint,uint,uint){
        return (pub,pri,inter);
    }
    function funPriv() private view returns(uint,uint,uint){
        return (pub,pri,inter);
    }
    function funInter() internal view returns(uint,uint,uint){
        return (pub,pri,inter);
    }
    function funExt() external view returns(uint,uint,uint){
        return (pub,pri,inter);
} 
}
