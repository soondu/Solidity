// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex5_5 {
    uint[] public array1=[97,98];
    string[] public array2=["apple", "banana", "coconut"];

    function getLength1() public view returns(uint){
        return array1.length;
    }
    function getLength2() public view returns(uint){
        return array2.length;
    }

    function addArray1(uint val) public {
        array1.push(val);
    }
    function addArray2(string memory val) public {
        array2.push(val);
    }
    function popArray1() public{
        array1.pop();
    }
    function popArray2() public{
        array2.pop();
    }
}