App = {
  web3Provider: null,
  contracts: {},
  names: new Array(),
  url: 'http://127.0.0.1:7545',

  init: function() {
    $.getJSON('../proposals.json', function(data) {
      var proposalsRow = $('#proposalsRow');
      var proposalTemplate = $('#proposalTemplate');

      for (i = 0; i < data.length; i ++) {
        proposalTemplate.find('.panel-title').text(data[i].name);
        proposalTemplate.find('img').attr('src', data[i].picture);
        proposalTemplate.find('.btn-vote').attr('data-id', data[i].id);

        proposalsRow.append(proposalTemplate.html());
        App.names.push(data[i].name);
      }
    });
    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there is an injected web3 instance?
    // if (typeof web3 !== 'undefined') {
    //   App.web3Provider = web3.currentProvider;
    // } else {
    //   // If no injected web3 instance is detected, fallback to the TestRPC
    //   App.web3Provider = new Web3.providers.HttpProvider(App.url);
    // }
    // web3 = new Web3(App.web3Provider);

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

  initContract: function() {
    $.getJSON('Ballot.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var voteArtifact = data;
      App.contracts.vote = TruffleContract(voteArtifact);

      // Set the provider for our contract
      App.contracts.vote.setProvider(App.web3Provider);

      App.populateAddress();

      return App.bindEvents();
    });
  },

  bindEvents: function() {
    $(document).on('click', '.btn-vote', App.handleVote);
    $(document).on('click', '#win-count', App.handleWinner);
    $(document).on('click', '#register', function(){ var ad = $('#enter_address').val(); App.handleRegister(ad); });
  },

  populateAddress : function(){
    new Web3(new Web3.providers.HttpProvider(App.url)).eth.getAccounts((err, accounts) => {
      jQuery.each(accounts,function(i){
        var optionElement = '<option value="'+accounts[i]+'">'+accounts[i]+'</option';
        jQuery('#enter_address').append(optionElement);  
      });
    });
  },
  
  handleRegister: function(addr){

    var voteInstance;
    App.contracts.vote.deployed().then(function(instance) {
      voteInstance = instance;
      web3.eth.defaultAccount = web3.eth.accounts[0]
      return voteInstance.register(addr);
    }).then(function(result){
        if(result){
            if(parseInt(result.receipt.status) == 1)
            alert(addr + " registration done successfully")
            else
            alert(addr + " registration not done successfully due to revert")
        } else {
            alert(addr + " registration failed")
        }   
    }).catch(function(err){
      console.log(err.message);
      alert(addr + " registration failed")
    });
  },

  handleVote: function(event) {
    event.preventDefault();
    var proposalId = parseInt($(event.target).data('id'));
    var voteInstance;
    
    var account = web3.eth.accounts[0];

    App.contracts.vote.deployed().then(function(instance) {
      voteInstance = instance;      
      return voteInstance.vote(proposalId, {from: account});
    }).then(function(result){
      if(result){
        console.log(result.receipt.status);
        if(parseInt(result.receipt.status) == 1)
          alert(account + " voting done successfully")
        else
          alert(account + " voting not done successfully due to revert")
      } 
      else {
        alert(account + " voting failed")
      }   
    }).catch(function(err){
      console.log(err.message);      
      alert(account + " voting failed")
    });
  },

  handleWinner : function() {
    console.log("To get winner");
    var voteInstance;
    App.contracts.vote.deployed().then(function(instance) {
      voteInstance = instance;
      web3.eth.defaultAccount = web3.eth.accounts[0]
      return voteInstance.reqWinner();  
    }).then(function(res){
      console.log(res);
      alert(App.names[res] + "  is the winner ! :)");
    }).catch(function(err){
      console.log(err.message);
    })
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
