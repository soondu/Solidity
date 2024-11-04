// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract NameRegistry{    
    struct Contractinfo{
        address contractOwner; //소유자 주소
        address contractAddress; //관리할 주소
        string description; //설명
    }
    uint public numContracts;
    mapping ( string => Contractinfo ) public registeredContracts; //이름->투자자 정보 모음
    constructor(){
        numContracts=0;
    }

    //등록하려는 정보는 등록한 소유자만 변경
    //등록된 컨트랙트의 이름을 매개변수로 받아서
    //등록된 컨트랙트 정보를 변경하려는 호출자가 등록된 컨트랙트의 소유자인지 확인
    modifier onlyOwner(string memory _name){
        require(registeredContracts[_name].contractOwner==msg.sender, "You are not the owner.");
        _; // Owner가 본인인지 확인. 정보를 변경!하려면 확인해야함.
    }

    //매핑에서 등록된 주소(.contractAddress)가 0일 때! 신규 등록
    function registerContract(string memory _name, address _contractAddress, string memory _descrip) public{
        require(registeredContracts[_name].contractAddress==address(0), "Already exists.");

        registeredContracts[_name]=Contractinfo(msg.sender, _contractAddress, _descrip); //신규 등록
        numContracts++;
    }
    //삭제
    function unregisterContract(string memory _name) public onlyOwner(_name){
        delete(registeredContracts[_name]);
        numContracts--;
    }

    //컨트랙트 소유자 변경
    function changeOwner(string memory _name, address _newOwner) public onlyOwner(_name){
        registeredContracts[_name].contractOwner=_newOwner; //Owner만 _name의 contract에서 owner변경
    }
    // 소유자 정보 확인. 누구나 가능 view로 보기
    function getOwner(string memory _name) public view returns(address){
        return registeredContracts[_name].contractOwner;
    }
    
    //컨트랙트 address 변경
    function setAddr(string memory _name, address _addr) public onlyOwner(_name){
        registeredContracts[_name].contractAddress=_addr; //Owner만 _name의 contract에서 address변경
    }
    // address 정보 확인. 누구나 가능 view로 보기
    function getAddr(string memory _name) public view returns(address){
        return registeredContracts[_name].contractAddress;
    }

    //컨트랙트 description 변경
    function setDescription(string memory _name, string memory _desc) public onlyOwner(_name){
        registeredContracts[_name].description=_desc; //Owner만 _name의 contract에서 description변경
    }
    // description 정보 확인. 누구나 가능 view로 보기
    function getDescription(string memory _name) public view returns(string memory){
        return registeredContracts[_name].description;
    }
}