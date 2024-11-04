// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract arith{
    uint a=5/5;
    int b=3-5;
    uint c=5%2;
    uint d=5**2;

    function show() public view returns(uint,int,uint,uint){
        return(a,b,c,d);
    }

    // function re(uint x) public pure returns(uint x){
    //     if(x>10){
    //         x=10;
    //     }
    // } 매개변수 이름과 반환값 이름 중복

    function loop(uint x) public pure returns(uint res){
        for(uint i=0;i<x;i++){
            res+=i;
        }
    }
}