// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Swapper {


    // Esta variable la dejamos para acceder a ella mientras el contrato este en desarrollo
    address public thisContract;

    // Direcciones del contrato
    IERC20 private tokenA; // ETH
    IERC20 private tokenB; // BTC

    // Direcciones de usuarios de BTC y ETH
    address public userA;
    address public userB;


    address private owner;




    constructor(address _tokenA, address _userA, address _tokenB, address _userB){
        tokenA = IERC20(_tokenA);
        userA = _userA;
        tokenB = IERC20(_tokenB);
        userB = _userB;
        
        owner = msg.sender;
        thisContract = address(this);
    }


    


    // Mapping

    struct Balances {
        uint256 ETHbalance;
        uint256 BTCbalance;
    }

    mapping(address => Balances ) public Users;



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
    function depositUserA(uint256 _amount) external OnlyUserA {
        if(tokenA.balanceOf(msg.sender) < _amount) revert ISwapper_CalledNotBalance();
        Users[msg.sender].ETHbalance += _amount;

        bool status = tokenA.transferFrom(msg.sender, address(this), _amount);
        if(!status) revert ISWapper_DeniedOrNotAllowance();
        emit Deposited(msg.sender,  _amount);

    }



    // DEPOSITAMOS TOKEN B
    function depositUserB(uint256 _amount) external OnlyUserB {
        if(tokenB.balanceOf(msg.sender) < _amount) revert ISwapper_CalledNotBalance();
        Users[msg.sender].BTCbalance += _amount;
        bool status = tokenB.transferFrom(msg.sender, address(this), _amount);
        if(!status) revert ISWapper_DeniedOrNotAllowance();
        emit Deposited(msg.sender, _amount);
        
    }

    
    

    // EJECUTAMOS EL SWAP
    function swap() external OnlyOwner {
        // Balance ETH usuario A
        uint256 swapAmountA = Users[userA].ETHbalance;
        // Balance BTC usuario B
        uint256 swapAmountB = Users[userB].BTCbalance;

        if(swapAmountA < 0 || swapAmountB < swapAmountA || swapAmountA < swapAmountB ) revert ISwapper_NoTokenToSwap();

        Users[userA].BTCbalance += swapAmountB;
        Users[userB].ETHbalance += swapAmountA;

        Users[userA].ETHbalance -= swapAmountA;
        Users[userB].BTCbalance -= swapAmountB;
        
        emit Swapped();
    }



    // RECLAMAMOS LOS TOKEN B DEL USER A LUEGO DEL SWAP
    function withdrawUserA(uint256 _amount) external OnlyUserA{
        if(tokenB.balanceOf(address(this)) < _amount) revert ISwapper_NoTokenToWithdraw();
        uint256 amount = Users[userA].BTCbalance;
        if(amount < 0 ) revert ISwapper_NoTokenToSwap();
        bool status = tokenB.transfer(userA, _amount);
        if(!status) revert ISWapper_DeniedOrNotAllowance();
        Users[userA].BTCbalance = 0;
        emit Withdrawn(msg.sender, _amount);
    }


    // RECLAMAMOS LOS TOKEN A DEL USER B LUEGO DEL SWAP
    function withdrawUserB(uint256 _amount) external OnlyUserB{
        if(tokenA.balanceOf(address(this)) < _amount) revert ISwapper_NoTokenToWithdraw();
        uint amount = Users[userB].ETHbalance;
        if(amount < 0) revert ISwapper_NoTokenToSwap();
        bool status = tokenA.transfer(userB, _amount);
        if(!status) revert ISWapper_DeniedOrNotAllowance();
        Users[userB].ETHbalance = 0;
        emit Withdrawn(msg.sender, _amount);
    }


    


    //VIEWS FUNCTIONS:
    //VIEWS FUNCTIONS:


    // Retorna el owner
    function OWNER() external view returns (address _owner) {
        return owner;
    }

    // Retorna el balance de los usuarios
    function userBalances(address _user) external view  returns (Balances memory){
        return Users[_user];
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

    function totalTokenBDeposited() external view returns (uint256 _totalTokenBDeposited){
        return tokenB.balanceOf(address(this));
    }



    





    //ERRORS:
    error ISwapper_OnlyOwner(); // <--  Revierte en caso de que la funcion no haya sido llamada por el propietario del contrato

    error ISwapper_CalledNotBalance(); // <--  Revierte si el usuario A no tiene tokens para gastar

    error ISwapper_NotBalances(); // <--  Error si no hay balance

    error ISwapper_NoTokenToSwap(); // <--   Revierte si no se ha depositado suficiente ficha B

    error ISwapper_NoTokenToWithdraw(); // <--   Se revierte si el propietario no tiene suficientes fichas B o A para retirarse.

    error ISWapper_UserNotAllowed(); // <--   Se revierte si las funciones de deposito no las ejecutan el usuarioA o el usuario B

    error ISWapper_DeniedOrNotAllowance(); // <--   Se revierte si no tiene fue aprovada previamente o esta fuera del allowance





    //EVENTS:
    //EVENTS:
    //EVENTS:

    event Deposited(address indexed _user, uint256 _amount); // <-- Evento se emite cuando un usuario deposita token A

    event Swapped(); // <-- Evento se emite cuando los tokens se han swapeado

    event Withdrawn(address indexed _user, uint256 _amount); // <--  Evento se emite cuando un usuario retira token B

}


    


/*

UserA
0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
ETH
0x462A574f3EceBa19b6f8D1b2D557C1873ed397b7


UserB
0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
BTC
0x4880c3921339adB0D7e0C3Be8c341D8b50973F56


Owner
0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
SwapContract
0x86BA8f41279c2B029EE140698D09c0766A71419f

*/