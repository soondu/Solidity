// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;


contract crowdFunding{    
    struct Investor{
        address addr;//투자자 주소
        uint amount; //투자액
    }
    mapping (uint=>Investor) public investors; //투자자 모음

    address public owner; //컨트랙트 소유자
    uint public numInvestors; //투자자 수
    uint public deadline; //마감일
    string public status; //모금활동 상태
    bool public ended; //모금 종료여부
    uint public goalAmount; //목표액
    uint public totalAmount; //총 투자액

    modifier onlyOwner{
        require(msg.sender==owner, "Error: caller is not the owner");
        _;
    }
    constructor(uint _duration, uint _goalAmount){
        owner=msg.sender;
        deadline=block.timestamp+_duration;
        goalAmount=_goalAmount * 1 ether;
        status="Funding";

        ended=false;
        numInvestors=0;
        totalAmount=0;
    }

    function fund() public payable {
        require(!ended, "Funding is over."); //모금이 끝났다면 처리 중단
        
        investors[numInvestors]=Investor(msg.sender, msg.value); //투자자정보를 매핑에 저장
        numInvestors++;
        totalAmount+=msg.value; //투자 총액 업데이트
    }

    function checkGoalReached() public onlyOwner{
        require(block.timestamp>=deadline, "Funding is not over yet."); //end아니면 처리 중단

        if(totalAmount>=goalAmount){ //모금액 달성 시
            status="Campaign Succedded";
            payable(owner).transfer(totalAmount);
        } // 소유자에게 모든 이더 송금
        else{
            status="Campaign Failed";
            for(uint i=0;i<numInvestors;i++){
                payable(investors[i].addr).transfer(investors[i].amount);
            } //각 투자자에게 투자금 돌려줌
        }
        ended=true;
    }

}