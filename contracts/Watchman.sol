pragma solidity ^0.4.8;

contract TokenTracker {
	function balanceOf(address who) returns (uint256) {}
}

contract Watchman {
	address owner;

	struct Token {
		address location;
		string name;
		bytes32 symbol;
	}
	
	struct User {
	    Token[] tokens;
	    mapping(address => bool) tokenTracked;
	}

	Token token;

	mapping(address => User) users;

	event TokenAdded(address location, string name, bytes32 symbol);

	modifier isOwner() {
		if (msg.sender != owner) {
			throw;
		}
		_;
	}
	
	function Watchman() {
	    owner = msg.sender;
	}

	function addToken(address location, string name, bytes32 symbol) {
		if (!users[msg.sender].tokenTracked[location]) {
			token.location = location;
			token.name = name;
			token.symbol = symbol;
			users[msg.sender].tokens.push(token);
			users[msg.sender].tokenTracked[location] = true;
			TokenAdded(location, name, symbol);
		} else {
			throw;
		}
	}

	function getTokenBalance(bytes32 symbol) returns (uint256 balance) {
		for (uint i = 0; i < users[msg.sender].tokens.length; i++) {
			if (users[msg.sender].tokens[i].symbol == symbol) {
				TokenTracker tracker = TokenTracker(users[msg.sender].tokens[i].location);
				return tracker.balanceOf(msg.sender); 
			}
		}
		return 0;
	}

	function getTokens() returns (bytes32[], uint256[]){
		Token[] tokens = users[msg.sender].tokens;
		bytes32[] memory symbols = new bytes32[](tokens.length);
		uint256[] memory balances = new uint256[](tokens.length);

		for (uint i = 0; i < tokens.length; i++) {
		    TokenTracker tracker = TokenTracker(tokens[i].location);
			symbols[i] = tokens[i].symbol;
			balances[i] = tracker.balanceOf(msg.sender);
		}

		return (symbols, balances); 
	}
}
