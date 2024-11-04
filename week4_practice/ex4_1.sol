// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Ex4_1 {
    int a=3-5;
    function myfun() public returns(int res){
        res=--a;
    }
    function show() public view returns(int res){
        res=a;
    }
}  