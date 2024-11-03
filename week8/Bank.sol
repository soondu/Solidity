// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Counter{
    address public owner;
    uint internal balance;
    event Deposit(address indexed from, uint256 amount); //주소와 금액, emit Deposit();
    event Withdrawal(address indexed to, uint256 amount);

    constructor(){
        owner=msg.sender;
    }    
    modifier onlyOwner(){
        require(owner==msg.sender, "Error: caller is not the owner");
        _;
    }

    // 계좌에 이더를 입금, Deposit 이벤트 발생
    function deposit() public payable{
        require(msg.value > 0, "Deposit amount must be greater than 0.");
        balance+=msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // 계좌에서 이더를 출금, Withdrawal 이벤트 발생
    function withdraw(uint256 amount) public{
        require(amount<=balance, "Balance is insufficient.");
        balance-=amount;
        payable(owner).transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // 호출자의 계좌 잔고 확인
    function getBalance() public view returns(uint256){
        return balance;
    }

    // 컨트랙트(소유자)의 잔고를 확인
    function getContractBalance() public view onlyOwner returns(uint256){
        return address(this).balance;
    }
    
}