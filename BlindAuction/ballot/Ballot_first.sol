// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot {
    struct Voter{
        uint weight;
        bool voted;
        uint vote;
    }
    struct Proposal{//제안 상세정보
        uint voteCount;
    }
    address chairperson;
    mapping (address=>Voter) public voters; //투표자 주소->정보
    Proposal[] public proposals; //투표수 담는 배열

    constructor(uint numProposals){
        chairperson=msg.sender;
        for(uint i=0;i<numProposals;i++){
            Proposal memory tmp=Proposal(0);
            proposals.push(tmp);
        }
    }

    modifier onlyChair(){
        require(chairperson==msg.sender,"Error: caller is not the chairmain.");
        _;
    }

    modifier validVoter() {
        require(voters[msg.sender].weight>0,"Error: caller is not the voter.");
        _;
    }

    function register (address _address) public onlyChair() {
        Voter memory tmp=Voter(1,false,0);
        if(_address==chairperson){
            tmp.weight=2;
        }
        voters[_address]=tmp;
    }
    function vote(uint num) public validVoter(){
        require(voters[msg.sender].voted==false,"Error: You have already voted.");
        require(num<proposals.length, "Error: Proposal index is out of range.");
        proposals[num].voteCount+=1; //투표수 업데이트
        voters[msg.sender].voted=true; //유권자 업데이트
        voters[msg.sender].vote=num;
    }
    function reqWinner() public view returns(uint index){
        uint maxNum=0;
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount>maxNum){
                maxNum=proposals[i].voteCount;
                index=i;
            }
        }
    }
}