// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex5_1 {
    mapping( string => uint ) public ages;

    function addMapping(string calldata _key, uint _amount) public{
        ages[_key]=_amount;
    }

    function getMapping(string calldata _key) public view returns(uint){
        return ages[_key];
    }
    // function showMapping() public view returns(mapping memory){
    //     return ages;
    // }
}