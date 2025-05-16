App = {
  web3Provider: null,
  contracts: {},
  url: 'http://127.0.0.1:7545',
  // network_id: 5777,

  biddingPhases: {  // event name
    "AuctionInit": { 'id': 0, 'text': "Bidding Not Started" },
    "BiddingStarted": { 'id': 1, 'text': "Bidding Started" },
    "RevealStarted": { 'id': 2, 'text': "Reveal Started" },
    "AuctionEnded": { 'id': 3, 'text': "Auction Ended" }
  },

  auctionPhases: {
    "0": "Bidding Not Started",
    "1": "Bidding Started",
    "2": "Reveal Started",
    "3": "Auction Ended"
  },

  init: function () {
    console.log("Checkpoint 0");
    return App.initWeb3();
  },

  initWeb3: function () {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      window.ethereum.request({ method: 'eth_requestAccounts' })
      .then(() => {
        console.log("Account access granted");
      })
      .catch((error) => {
        // User denied account access...
        console.error("User denied account access", error);
      });
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider(App.url); // App.url is your fallback URL (e.g., http://localhost:7545)
    }
    
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function () {
    $.getJSON('BlindAuction.json', function (data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var auctionArtifact = data;
      App.contracts.auction = TruffleContract(auctionArtifact);
      // Set the provider for our contract
      App.contracts.auction.setProvider(App.web3Provider);
      App.getCurrentPhase();
 
      return App.bindEvents();
    });
  },

  bindEvents: function () {
    $(document).on('click', '#submit-bid', App.handleBid);
    $(document).on('click', '#submit-reveal', App.handleReveal);
    $(document).on('click', '#change-phase', App.handlePhase);
    $(document).on('click', '#withdraw-bid', App.handleWithdraw);    
    $(document).on('click', '#generate-winner', App.handleWinner);    
  },

  getCurrentPhase: function() {
  App.contracts.auction.deployed().then(function(instance) {
    return instance.currentPhase();
  }).then(function(result) {
    console.log("Raw currentPhase result:", result); // 디버그 메시지 추가

    App.currentPhase = result.toString(); // BigNumber를 문자열로 변환
    var notificationText = App.auctionPhases[App.currentPhase];
    console.log("Current Phase:", App.currentPhase);
    console.log("Notification Text:", notificationText);
    $('#phase-notification-text').text(notificationText);
  }).catch(function(error) {
    console.error("Error getting current phase:", error);
  });
},


handlePhase: function () {
  App.contracts.auction.deployed().then(function (instance) {
    return web3.eth.getAccounts().then(accounts => {
      if (accounts.length === 0) {
        toastr["error"]("No account found. Please connect to MetaMask.");
        throw new Error("No account found.");
      }
      web3.eth.defaultAccount = accounts[0];
      return instance.advancePhase({ from: web3.eth.defaultAccount });
    });
  }).then(function (result) {
    console.log("advancePhase result:", result);

    if (result && parseInt(result.receipt.status) === 1) {
      if (result.logs.length > 0) {
        App.showNotification(result.logs[0].event);
      } else {
        App.showNotification("AuctionEnded");
      }

      // Phase 업데이트
      return App.contracts.auction.deployed().then(instance => instance.currentPhase());
    } else {
      throw new Error("Error in changing to next Phase");
    }
  }).then(function (currentPhase) {
    App.currentPhase = currentPhase.toString();
    console.log("New Phase:", App.currentPhase);
    var notificationText = App.auctionPhases[App.currentPhase];
    $('#phase-notification-text').text(notificationText);

    // Bidding phase가 시작되면 타이머 시작
    if (App.currentPhase === '1') { // '1'은 Bidding Started 상태
      startCountdown(120); // 2분 (120초) 카운트다운
    }
  }).catch(function (err) {
    toastr["error"]("Error in changing to next Phase");
    console.error(err);
  });
},




  handleBid: function () {
    // event.preventDefault();
    var bidValue = $("#bet-value").val();
    var msgValue = $("#message-value").val();
    App.contracts.auction.deployed().then(function (instance) {
      bidInstance = instance;
      web3.eth.defaultAccount=web3.eth.accounts[0];
      return bidInstance.bid(bidValue, { value: web3.toWei(msgValue, "ether") });
    }).then(function (result) {
      if (result) {
        console.log(result.receipt.status);
        if (parseInt(result.receipt.status) == 1)
          toastr.info("Your Bid is Placed!", "", { "iconClass": 'toast-info notification0' });
        else
          toastr["error"]("Error in Bidding. Bidding Reverted!");
      } else {
        toastr["error"]("Bidding Failed!");
      }
    }).catch(function (err) {
      console.log(err);
      toastr["error"]("Bidding Failed!");
    });    
  },

  handleReveal: function () {
    console.log("reveal button clicked");
    // event.preventDefault();
    var bidRevealValue = $("#bet-reveal").val();
    console.log(bidRevealValue);
    console.log(parseInt(bidRevealValue));
    var bidRevealSecret = $("#password").val();
    console.log(bidRevealSecret);

    App.contracts.auction.deployed().then(function (instance) {
      bidInstance = instance;
      web3.eth.defaultAccount=web3.eth.accounts[0];
      return bidInstance.reveal(parseInt(bidRevealValue), bidRevealSecret);
    }).then(function (result) {
      if (result) {
        console.log(result.receipt.status);
        if (parseInt(result.receipt.status) == 1)
          toastr.info("Your Bid is Revealed!", "", { "iconClass": 'toast-info notification0' });
        else
          toastr["error"]("Error in Revealing. Bidding Reverted!");
      } else {
        toastr["error"]("Revealing Failed!");
      }
    }).catch(function (err) {
      console.log(err);
      toastr["error"]("Revealing Failed!");
    });    
  },
  
  

  handleWinner: function () {
    console.log("To get winner");
    var bidInstance;
    App.contracts.auction.deployed().then(function (instance) {
      bidInstance = instance;
      web3.eth.getAccounts().then(accounts => {
        if (accounts.length === 0) {
          toastr["error"]("No account found. Please connect to MetaMask.");
          return;
        }
        web3.eth.defaultAccount = accounts[0];
      });
      return bidInstance.auctionEnd();
    }).then(function (res) {
      console.log(res);
      var winner = res.logs[0].args.winner;
      var highestBid = res.logs[0].args.highestBid.toNumber();
      toastr.info("Highest bid is " + highestBid + "<br>" + "Winner is " + winner, "", { "iconClass": 'toast-info notification3' });
    }).catch(function (err) {
      console.log(err.message);
      toastr["error"]("Error!");
    })
  },

  handleWithdraw: function() {
    console.log("Inside handleWithdraw")
    App.contracts.auction.deployed().then(function(instance) {
      // console.log("Trying to call withdraw with currentAccount: " + App.currentAccount);
      web3.eth.defaultAccount=web3.eth.accounts[0];
      console.log("Trying to call withdraw with currentAccount: " + web3.eth.defaultAccount);
      //return instance.withdraw({from: App.currentAccount });
      return instance.withdraw();
    }).then(function(result) {
      if(result.receipt.status) {
        toastr.info('Your bid has been withdrawn');
      }  
    }).catch(function(error) {
      console.log(error.message);
      toastr["error"]("Error in withdrawing the bid");
    })
  },

  //Function to show the notification of auction phases
  showNotification: function (phase) {
    var notificationText = App.biddingPhases[phase];
    $('#phase-notification-text').text(notificationText.text);
    toastr.info(notificationText.text, "", { "iconClass": 'toast-info notification' + String(notificationText.id) });
  }
};


$(function () {
  $(window).load(function () {
    App.init();
    //Notification UI config
    toastr.options = {
      "showDuration": "1000",
      "positionClass": "toast-top-left",
      "preventDuplicates": true,
      "closeButton": true
    };
  });
});


// 카운트다운을 시작하는 함수
function startCountdown(durationInSeconds) {
  let timerElement = document.getElementById('bidding-time');
  if (!timerElement) {
    console.error("Timer element with id 'bidding-time' not found.");
    return;
  }

  let remainingTime = durationInSeconds;

  const interval = setInterval(() => {
    const minutes = Math.floor(remainingTime / 60);
    const seconds = remainingTime % 60;
    timerElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

    if (remainingTime <= 0) {
      clearInterval(interval);
      timerElement.textContent = "Time's up!";
    }

    remainingTime -= 1;
  }, 1000);
}


//Bidding 상태가 되면 타이머를 시작
// document.getElementById('change-phase').addEventListener('click', async () => {
//   try {
//     const instance = await App.contracts.auction.deployed();
//     await instance.advancePhase({ from: web3.eth.defaultAccount });
//     const phase = await instance.currentPhase();

//       // 화면에 현재 phase 표시
//       App.currentPhase = phase.toString();
//       document.getElementById('phase-notification-text').innerText = App.auctionPhases[App.currentPhase];

//       // Bidding phase가 시작되면 타이머 시작
//       if (phase.toString() === '1') { // Phase.Bidding == 1
//           startCountdown(120); // 2분 (120초) 카운트다운
//       }
//   } catch (error) {
//       console.error('Error advancing phase:', error);
//   }
// });

// 이미지 변경을 위한 파일명 배열
const images = [
  'img/alos1.png',
  'img/alos2.png',
  'img/alos3.png',
  
  'img/alos100.png'
];

let currentIndex = 0; // 현재 이미지 인덱스

// Reveal 버튼 클릭 이벤트 리스너
document.getElementById('submit-reveal').addEventListener('click', function() {
  if (currentIndex < images.length - 2) {
    currentIndex++;
    document.getElementById('alos-image').src = images[currentIndex];
  }
});

document.getElementById('generate-winner').addEventListener('click', function(){
  document.getElementById('alos-image').src = images[3];
});
