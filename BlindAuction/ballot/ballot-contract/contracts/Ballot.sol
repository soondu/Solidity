// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Ballot2 {
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

    enum Phase {Init, Regs, Vote, Done} //단계 순서
    Phase public currentPhase=Phase.Init;

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
    modifier validPhase(Phase reqPhase){
        require(currentPhase == reqPhase, "Error: Incorrect Phase.");
        _;
    }

    function advancePhase() public onlyChair() {
        for(uint i=0;i<4;i++){
            if(currentPhase==Phase(i)){ //i=3에서 부르지 않음
                currentPhase=Phase(i+1);
                break;
            }
        }
    }
    //투표자 등록->투표->개표
    function register (address _address) public validPhase(Phase(1)) onlyChair() {
        Voter memory tmp=Voter(1,false,0);
        if(_address==chairperson){
            tmp.weight=2;
        }//투표자 주소=>정보 담음
        voters[_address]=tmp;
    }
    function vote(uint num) public validPhase(Phase(2)) validVoter(){
        require(voters[msg.sender].voted==false,"Error: You have already voted.");
        require(num<proposals.length, "Error: Proposal index is out of range.");
        proposals[num].voteCount+=1; //투표수 업데이트
        voters[msg.sender].voted=true; //유권자 업데이트
        voters[msg.sender].vote=num;
    }
    function reqWinner() public validPhase(Phase(3)) view returns(uint index){
        uint maxNum=0;
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount>maxNum){
                maxNum=proposals[i].voteCount;
                index=i;
            }
        }
    }
}