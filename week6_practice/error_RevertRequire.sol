// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ex6_3{
    function runRevert(uint _num) public pure returns(uint){
        if(_num<=3){
            revert("Revert Error");
        }
        return _num;
    }
    
    function runRequire(uint _num) public pure returns(uint){
        if(_num>3){
            revert("Require Error");
        }
        return _num;
    }
}
