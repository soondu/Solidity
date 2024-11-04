// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Monitor {
    string public name;
    uint private age=10;
    constructor(string memory _name){
        name=_name;
    }
    function getAge() public view returns(uint){
        return age;
        //encapsulation. 주어진 함수를 통해서만 변수에 접근 가능
    }
}

contract Computer{
    Monitor public monitor;
    constructor(){
        monitor=new Monitor("Samsung");
    }
    function getMonitor() public view returns(string memory){
        return monitor.name();
    }
    function getAge() public view returns(uint){
        return monitor.getAge();
    }
}