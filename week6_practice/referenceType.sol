// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract referType{
    uint num=1;
    uint[] public array1=[1,2,3];
    //uint[] public array2;
//  array2.push(4); 상태 변수 간 직접 참조는 안됨. 함수 내에서 해야해.
    
    function refer(uint val) public returns (uint[] memory){
    //  함수 내에서 상태변수로 설정
        uint[] storage array2=array1;
    //  uint storage num=1; 변수 위치 정하기는 참조타입만 가능

        array2.push(val);
    // array2에 push해도 array1값은 달라지지 않음
        return array2;
    } 

    // array1 출력
    function getArray1() public view returns (uint[] memory) {
        return array1;
    }
    // array2 출력 -> 상태변수만 함수에서 변수 사용할 수 있어
    // function getArray2() public view returns (uint[] memory) {
    //     return array2;
    // }
}