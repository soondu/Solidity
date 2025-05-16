// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Khash{
    function hashMe(uint value, bytes32 password) public pure returns(bytes32 hashedValue) {
        hashedValue=keccak256(abi.encodePacked(value,password));
    }
}

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid; //비번
        uint deposit; //예치금
    }
    //Khash public khash;
    // Init - 0; Bidding - 1; Reveal - 2; Done - 3
    enum Phase { Init, Bidding, Reveal, Done }
    Phase public currentPhase = Phase.Init;

    // Owner
    address payable public beneficiary;

    // Keep track of the highest bid,bidder
    address public highestBidder;
    uint public highestBid = 0; //최대 입찰가

    // 입찰자의 입찰 해시값과 예치금에 대한 매핑
    mapping(address => Bid) public bids;
    // 입찰금 반환을 위한 매핑
    mapping(address => uint) pendingReturns;


    // Events
    event AuctionEnded(address winner, uint highestBid);
    event BiddingStarted();
    event RevealStarted();
    event AuctionInit();

    // Modifiers
    constructor() {
        beneficiary = payable(msg.sender);
        
        emit AuctionInit();
    }
    modifier onlyOwner(){
        require(msg.sender == beneficiary);
        _;
    }

    function advancePhase() public onlyOwner {
        if(currentPhase==Phase(0)){
            currentPhase = Phase(1);
            emit BiddingStarted();
        }else if (currentPhase == Phase(1)){
            currentPhase = Phase(2);
            emit RevealStarted();
        }
        else if(currentPhase==Phase(2)){
            currentPhase=Phase(3);
        }
        else if(currentPhase==Phase(3)){
            currentPhase=Phase(0);
        }
    }

    //msg.value=예치금    
    //blindBid=입찰가+비밀번호
    function bid(bytes32 blindBid) public payable {
        //한번씩 입찰 가능
        require(bids[msg.sender].deposit == 0,"You've already deposited.");
        //Bidding단계여야 입찰 가능
        require (currentPhase == Phase.Bidding,"Auction not started yet");
        //예치금이 0보다 커야 함
        require (msg.value>0,"Insufficient bid amount");

        uint deposit=msg.value/1 ether;
        //입찰가와 비밀번호를 해시값으로
        bids[msg.sender] = Bid(blindBid, deposit);
    }

function reveal(uint value, bytes32 secret) public payable {
    // value=입찰가, secret=비밀번호
    require(currentPhase == Phase.Reveal, "Auction not finished yet");
    require(bids[msg.sender].deposit > 0, "You've already revealed"); // 재진입 방지

    // 입찰가와 비밀번호가 제출된 해시값과 일치하는지 확인
    bytes32 hashedValue = keccak256(abi.encodePacked(value, secret));
    require(hashedValue == bids[msg.sender].blindedBid, "Invalid bid: hash mismatch");

    // 예치금이 입찰가보다 크거나 같은지 확인
    require(bids[msg.sender].deposit >= value, "Insufficient deposit for the bid");

    // 예치금에서 입찰가를 차감한 금액을 전송
    uint refundAmount = (bids[msg.sender].deposit - value) * 1 ether;
    if (refundAmount > 0) {
        (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
        require(success, "Transfer failed");
    }
    bids[msg.sender].deposit = 0; // 예치금을 비움

    // 최고 입찰가와 비교
    if (highestBid < value) {
        highestBid = value;
        highestBidder = msg.sender;
        // 최고 입찰가보다 작으면 입찰 탈락자의 입찰금을 매핑에 추가
        pendingReturns[msg.sender] = value;
    }
}


    //입찰 탈락자는 자신의 입찰금을 출금
    function withdraw() public {
        // 낙찰되지 않은 입찰금 반환
        require(currentPhase == Phase.Done,"Auction not finished");
        //입찰 탈락자만 withdraw할 수 있음
        require (pendingReturns[msg.sender] > 0, "You have no pending returns");
        
        //pendingReturns에 저장되어 있는 값을 나에게로 송금
        payable(msg.sender).transfer(pendingReturns[msg.sender]*1 ether);
        delete pendingReturns[msg.sender];  // 재진입 공격 방지
        delete bids[msg.sender];
    }

    // Send the highest bid to the beneficiary and end the auction
    function auctionEnd() public onlyOwner{
        require (currentPhase == Phase.Done,"Auction not finished yet");
        //owner가 경매 끝내고 수혜자에게 낙찰금 전송
        beneficiary.transfer(highestBid* 1 ether);
        emit AuctionEnded(highestBidder, highestBid);
        
        
        //상태 리셋     
        delete pendingReturns[highestBidder];  // 재진입 공격 방지
        delete bids[highestBidder]; //bids도 초기화
        //currentPhase = Phase.Init;
        highestBid = 0;
        highestBidder=address(0);
    }
}
