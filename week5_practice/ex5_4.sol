// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex5_4 {
    uint[] public array1=[97,98];
    string[5] public array2=["apple", "banana", "coconut"];

    function getLength1() public view returns(uint){
        return array1.length;
    }
    function getLength2() public view returns(uint){
        return array2.length;
    }

    function addArray1(uint _value) public {
        array1.push(_value);
    }
    function changeArray2(uint idx, string memory val) public{
        array2[idx]=val;
    }
}