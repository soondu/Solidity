// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

abstract contract System{
    uint internal version;
    bool internal errorPass;
    function Version() internal virtual;
    function Errorr() internal virtual;
    
    function getN() public returns(uint, bool){
        Version(); Errorr();
        return(version, errorPass);
    }
}
contract Computer is System{
    function Version() internal override {
        version=3;
    }
    function Errorr() internal override{
        errorPass=true;
    }
}

interface Device{
    function Version() external returns(uint);
    function Errorr() external returns(bool);
    
    function getN() external returns(uint, bool);
}
contract SmartPhone is Device{
    function Version() public pure override returns(uint){
        return 100;
    }
    function Errorr() public pure override returns(bool){
        return true;
    }
    function getN() public pure override returns(uint, bool){
        return(Version(), Errorr());
    }
}
contract Tablet is Device{
    function Version() public pure override returns(uint){
        return 200;
    }
    function Errorr() public pure override returns(bool){
        return true;
    }
    function getN() public pure override returns(uint, bool){
        return(Version(), Errorr());
    }
}
contract Load{
    function versionCheck(address ad) public returns(uint, bool){
        return Device(ad).getN();
    }
}