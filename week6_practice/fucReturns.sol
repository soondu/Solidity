// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract fucReturns{

    function Fun1(uint num1, uint num2) public pure returns(uint a, uint b){
        a= ++num1; b= ++num2;
    }

    function Fun2() public pure returns(uint age, string memory name){
        age=20;
        name="yuyeon";
    }

    // int a; uint b; bool c; bytes d; string e; address f;
    // function Fun3() public view returns(int,uint,bool, bytes memory, string memory, address){
    //     return(a,b,c,d,e,f);
    // }

}