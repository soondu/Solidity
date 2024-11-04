// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Counter{
    uint internal count;
    function get() public view returns(uint){
        return count;
    }
    function inc() public {
        count+=1;
    }
    function dec() public {
        count-=1;
    }
}