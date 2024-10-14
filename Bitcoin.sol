// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Le indicamos al contrato que use el estandar ERC20 
contract BitcoinToken is ERC20 {

    address public owner;

    // Esta variable la dejamos para acceder a ella mientras el contrato este en desarrollo
    address public addressToken;

    // Indicamos el nombre del contrato y el simbolo
    constructor() ERC20 ("Bitcoin", "BTC") {
        // El creador del contrato recibe un suministro inicial
        _mint(msg.sender, 1000);
        owner = msg.sender;
        addressToken = address(this);
    }
    
}



