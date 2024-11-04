// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract varType{
    // uint public num1=1;
    // uint private num2=2;
    // uint internal num3=3;
    // function getNum() external view returns(uint,uint,uint){
    //     return (num1,num2,num3);
    // }
    function getNum(uint res) internal pure returns(uint){
        return res;
    }
    event updateNum(uint res);
    function doWhile(uint a) public returns(uint res){
        do{
            res+=a;
            a++;
            //getNum(res);
            emit updateNum(res);
        }while(a<10);
    }
}