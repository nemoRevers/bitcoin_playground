// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20{
    constructor (string memory name, string memory  symbol, address account, uint256 amount) ERC20(name, symbol){
        _mint(account,amount);
    }
}