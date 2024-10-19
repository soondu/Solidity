// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Ex4_22 {
function funExt() external pure returns(uint) {
return 2;
}
function funPri() private pure returns(uint) {
return 3;
}
/*
function outPutExt() public pure returns(uint) {
return funExt();
} 
*/
// external함수는 내부 접근 불가
// this.funcExt(); 이용해 external함수 내부 접근

function outPutPri() public pure returns(uint) {
return funPri();
} 
}
