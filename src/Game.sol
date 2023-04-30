//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/CountersUpgradeable.sol";

contract Game is Initializable, ERC721Upgradeable, OwnableUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    CountersUpgradeable.Counter public tokenId;
    CountersUpgradeable.Counter public monsterId;

    enum State {
        win,
        loss
    }

    enum Status {
        free,
        engaged
    }

    string public baseUri;
    uint256 internal timeSet;

    mapping(address => uint256) public addressToMonsterId;
    mapping(uint256 => address) public monsterIdToAddress;
    mapping(uint256 => bool) public presentInMonsters;
    mapping(uint256 => Status) public status;
    mapping(address => mapping(uint256 => State)) public state;
    mapping(uint256 => bool) public monsterReadyToAttack;

    function initialize(string memory _baseUri) public initializer {
        __ERC721_init("GAME", "GM");
        __Ownable_init();
        baseUri = _baseUri;
    }

    function mint(address _address) internal {
        tokenId.increment();
        uint256 currentTokenId = tokenId.current();
        _safeMint(_address, currentTokenId);
        tokenURI(currentTokenId);
    }

    function generateMonster() public payable {
        require(msg.value == 0.01 ether, "Pay 0.01 ether to mint a monster!");
        monsterId.increment();
        uint256 currentTokenId = monsterId.current();
        // require(addressToMonster[msg.sender] < 2);
        _safeMint(msg.sender, currentTokenId);
        addressToMonsterId[msg.sender] = currentTokenId;
        monsterIdToAddress[currentTokenId] = msg.sender;
        presentInMonsters[currentTokenId] = true;

        status[currentTokenId] = Status.free;
        monsterReadyToAttack[currentTokenId] = true;
    }

    function attack(uint256 _enemyTokenId) public payable {
        require(
            msg.value == 0.01 ether,
            "Please pay 0.01 ether to start an attack"
        );
        uint256 _attackerTokenId = addressToMonsterId[msg.sender];
        require(monsterReadyToAttack[_attackerTokenId] == true);
        uint256 number = generateNumber();
        if (number > 50) {
            state[msg.sender][_attackerTokenId] = State.win;
            address looser = monsterIdToAddress[_enemyTokenId];
            state[looser][_enemyTokenId] = State.loss;
            mint(msg.sender);
        } else {
            state[msg.sender][_attackerTokenId] = State.loss;
            address winner = monsterIdToAddress[_enemyTokenId];
            state[winner][_enemyTokenId] = State.loss;
            mint(winner);
        }

        status[_enemyTokenId] = Status.free;
        status[_attackerTokenId] = Status.free;
        timeSet = block.timestamp + 1 hours;
        monsterReadyToAttack[_attackerTokenId] = false;
        coolDown(_attackerTokenId);
    }

    function chooseOpponent(uint256 _enemyTokenId) public {
        uint256 _attackerTokenId = addressToMonsterId[msg.sender];
        require(
            status[_enemyTokenId] == Status.free &&
                status[_attackerTokenId] == Status.free
        );

        require(
            presentInMonsters[_enemyTokenId] &&
                presentInMonsters[_attackerTokenId]
        );
        status[_enemyTokenId] = Status.engaged;
        status[_attackerTokenId] = Status.engaged;
    }

    function generateNumber() private view returns (uint256) {
        uint256 nonce = 1;
        uint256 number = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        ) % 100;
        return number + 1;
    }

    function coolDown(uint256 _tokenId) internal waitTillCoolingDown {
        monsterReadyToAttack[_tokenId] = true;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri;
    }

    function withdraw() public onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Payment failed");
    }

    modifier waitTillCoolingDown() {
        require(block.timestamp > timeSet);
        _;
    }
}

// 0xc79F6DbB9FfAEC3f28eDEACB1Fe921f3c9B3eC25
