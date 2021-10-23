pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract nftToken {

    struct Token {
        string nameFilm;
        uint createYear;
        string genre;
        uint durationMinutes;
    }

    Token[] tokenArr;
    mapping (uint => uint) tokenToOwner;
    mapping (uint => uint) tokenToPrice;

    // modifier: verification of the readiness for payment
    modifier checkAccept {
		tvm.accept();
		_;
	}

    modifier checkOwner(uint _tokenID) {
		require(msg.pubkey() == tokenToOwner[_tokenID], 104);
		_;
	}

    modifier checkUniqueName(string _name) {
        for(uint i = 0; i < tokenArr.length; i++) {
            require(_name != tokenArr[i].nameFilm, 103);
        }
		_;
	}

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        // require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

    function createToken(string nameFilm, uint createYear,string genre, uint durationMinutes) public checkUniqueName(nameFilm) checkAccept {
        tokenArr.push(Token(nameFilm, createYear, genre, durationMinutes));
        uint keyAsLastNum = tokenArr.length - 1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();
    }

    // get the token owner
    function getTokenOwner(uint tokenID) public checkAccept  view returns (uint) {
        return tokenToOwner[tokenID];
    }

    // get the token information
    function getTokenInfo(uint tokenID) public checkAccept view returns (string tokenName, uint tokenYear, string tokenGenre, uint tokenDuration) {
        tokenName = tokenArr[tokenID].nameFilm;
        tokenYear = tokenArr[tokenID].createYear;
        tokenGenre = tokenArr[tokenID].genre;
        tokenDuration = tokenArr[tokenID].durationMinutes;
    }

    // put the token up for sale (specify the price)
    function putTokenSale(uint tokenID, uint tokenPrice) public checkAccept checkOwner(tokenID){
        tokenToPrice[tokenID] = tokenPrice;
    }

    // get the token price
    function getTokenPrice(uint tokenID) public checkAccept view returns (uint) {
        return tokenToPrice[tokenID];
    }
}
