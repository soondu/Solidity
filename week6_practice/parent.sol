// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Animal {
    string public species;
    constructor(string memory _name){
        species=_name;
    }
    function getSpecies() public view returns(string memory){
        return species;
    }
}

contract Tiger is Animal{
    constructor(string memory _name) Animal(_name){}
    
}

contract Dog is Animal{
    constructor(string memory _name) Animal(_name){}
    
}

contract AnimalSet{
    Animal public tiger;
    Animal public dog;
    constructor(string memory name1, string memory name2){
        tiger= new Tiger(name1);
        dog= new Dog(name2);
    }
    
    function getAllNames() public view returns(string memory, string memory){
        return(tiger.getSpecies(), dog.getSpecies());
    }

}
