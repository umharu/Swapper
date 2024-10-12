// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Le indicamos al contrato que use el estandar ERC20 
contract GabrielToken is ERC20 {

    // Indicamos el nombre del contrato y el simbolo
    constructor(uint256 initialSupply) ERC20 ("Gabriel", "GAB") {
        // El creador del contrato recibe un suministro inicial
        _mint(msg.sender, initialSupply);
    }
}



