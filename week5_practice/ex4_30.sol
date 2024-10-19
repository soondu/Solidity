// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex4_30 {
    function fun1() public pure returns(uint){
        uint result=0;
        uint a=0;
        do{
            result+=a;
            a++;
        }while(a<3);
        
        return result;
    }
}