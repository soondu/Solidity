// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

// 구조체를 적용한 배열과 매핑
contract Ex5_8 {
    struct Human {
        string name;
        uint age;
        string job;
    }
    Human public human1=Human("yuyeon",20,"student"); //인스턴스 생성
    Human public human2;

    function getHuman1() public view returns(Human memory){
        return human1;
    }
    
    function getName(Human calldata h) public pure returns(string memory){
        return h.name;
    }
    function getHuman2() public view returns(Human memory){
        return human2;
    }
    function initializeHuman2(string memory _name, uint _age, string memory _job) public{
        human2=Human(_name,_age,_job);
    }
    


}
