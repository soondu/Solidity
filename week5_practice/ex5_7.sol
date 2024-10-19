// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex5_7 {
    string[] public fruit=["apple", "banana", "coconut"];

    function linearSeach(string memory word) public view returns(uint256,string memory){
        for(uint i=0;i<fruit.length; i++){
            if(keccak256(bytes(fruit[i]))==keccak256(bytes(word))){
                return(i, fruit[i]);
            }//keccak256: 해시값 비교
        }
        return(0,"Nothing"); //찾는 단어가 없으면 nothing반환
    }
}