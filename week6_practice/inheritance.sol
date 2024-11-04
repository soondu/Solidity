// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Student {
    string public name;
    string public depart;
    string internal schoolName="Sogang";
    constructor(string memory _name){
        name=_name;
    }
    function setDepart(string memory str) public{
        depart=str;
    }
}

contract ArtStudent is Student{
    constructor(string memory _name) Student(_name){}
    function changeSchoolName() public {
        schoolName="Solidity";
    }
    function getSchoolName() public view returns(string memory){
        return schoolName;
    }
}
