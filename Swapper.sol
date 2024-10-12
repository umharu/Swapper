// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Swapper {


    IERC20 public tokenA; // GAB
    IERC20 public tokenB; // ARG

    address public userA;
    address public userB;
    address public owner;






    constructor(address _tokenA, address _userA, address _tokenB, address _userB){
        tokenA = IERC20(_tokenA);
        userA = _userA;
        tokenB = IERC20(_tokenB);
        userB = _userB;
        
        owner = msg.sender;
    }





    struct Balances {
        uint256 GABbalance;
        uint256 ARGbalance;
    }

    // Mappings
    // Mappings
    mapping(address => Balances ) public Users;
    mapping(address => uint256) public GABdeposits;
    mapping(address => uint256) public ARGdeposits;




    // modificador para controlar las funciones de deposito
    modifier OnlyOwner(){
        if(owner != msg.sender) revert ISwapper_OnlyOwner();
        _;
    }

    modifier OnlyUserA(){
        if(userA != msg.sender) revert ISWapper_UserNotAllowed();
        _;
    }

    modifier OnlyUserB(){
        if(userB != msg.sender) revert ISWapper_UserNotAllowed();
        _;
    }


    // DEPOSITAMOS TOKEN A
    function deposit(uint256 _amount) external OnlyUserA {
        if(Users[msg.sender].GABbalance == 0){
           Users[msg.sender].GABbalance += _amount;
        }
        bool status = tokenA.transferFrom(msg.sender, address(this), _amount);
        if(!status) revert ISWapper_DeniedOrNotAllowance();
        GABdeposits[userA] += _amount;
        emit Deposited(userA,  _amount);
    }




    function depositUserB() external OnlyUserB {}


    function swap() external OnlyOwner {}

    function withdraw() external OnlyOwner{}

    function withdrawUserB() external OnlyOwner{}


    


    //VIEWS FUNCTIONS:
    //VIEWS FUNCTIONS:


    // Retorna el owner
    function OWNER() external view returns (address _owner) {
        return userB;
    }

    // Retorna el tokenA
    function viewTokenA() external view returns (IERC20 _tokenA) {
        return tokenA;
    }

    // Retorna el tokenB
    function viewtokenB() external view returns (IERC20 _tokenB){
        return tokenB;
    }


    // Returns the total amount of token A deposited
    function totalTokenADeposited() external view returns (uint256 _totalTokenADeposited){
        return tokenA.balanceOf(address(this));
    }











    //ERRORS:
    //ERRORS:
    //ERRORS:

    // Revierte en caso de que la funcion no haya sido llamada por el propietario del contrato
    error ISwapper_OnlyOwner();

    // Revierte si no se ha depositado suficiente ficha B
    error ISwapper_NoTokenB();

    // Se revierte si el propietario no tiene suficientes fichas B o A para retirarse.
    error ISwapper_NoTokenToWithdraw();

    // Se revierte si las funciones de deposito no las ejecutan el usuarioA o el usuario B
    error ISWapper_UserNotAllowed();

    // Se revierte si no tiene fue aprovada previamente o esta fuera del allowance
    error ISWapper_DeniedOrNotAllowance();

    //EVENTS:
    //EVENTS:
    //EVENTS:

    // el usuario que deposita   =>  _user
    // cantidad que se deposita  =>  _amount
    event Deposited(address indexed _user, uint256 _amount); // <-- Evento se emite cuando un usuario deposita token A

    
    event Swapped(); // <-- Evento se emite cuando los tokens se han swapeado


    // el usuario que reclama     =>  _user
    // la cantidad que se reclama =>  _amount
    event Withdrawn(address indexed _user, uint256 _amount); // <--  Evento se emite cuando un usuario retira token B
}