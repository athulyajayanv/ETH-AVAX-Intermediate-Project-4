// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenGamingToken is ERC20, Ownable, ERC20Burnable {
    // Enum for different game actions
    enum Action { PLAY, WIN, LOSE, PURCHASE, REDEEM, TRANSFER, BURN, RECEIVE }

    // Struct to store action details
    struct GameAction {
        Action action;
        uint256 amount;
    }

    // Mapping to store actions taken by each player
    mapping(address => GameAction[]) public playerActions;

    event TokensEarned(address indexed recipient, uint256 amount, string action);
    event TokensTransferred(address indexed sender, address indexed recipient, uint256 amount);
    event TokensBurned(address indexed burner, uint256 amount);
    event TokensRedeemed(address indexed redeemer, uint256 amount);

    constructor(address initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {}

    // Function to mint tokens to a player
    function mintTokens(address recipient, uint256 amount) external onlyOwner {
        _mint(recipient, amount);
        _recordAction(recipient, Action.PLAY, amount);
        emit TokensEarned(recipient, amount, "Tokens earned from gameplay");
    }

    // Function to transfer tokens between players
    function transferTokens(address to, uint256 amount) external {
        require(to != address(0), "Invalid recipient");
        require(amount > 0 && amount <= balanceOf(msg.sender), "Invalid amount");

        _transfer(msg.sender, to, amount);
        _recordAction(msg.sender, Action.TRANSFER, amount);
        _recordAction(to, Action.RECEIVE, amount);
        emit TokensTransferred(msg.sender, to, amount);
    }

    // Function to burn tokens
    function burnTokens(uint256 amount) external {
        require(amount > 0 && amount <= balanceOf(msg.sender), "Invalid amount");

        _burn(msg.sender, amount);
        _recordAction(msg.sender, Action.BURN, amount);
        emit TokensBurned(msg.sender, amount);
    }

    // Function to redeem tokens
    function redeemTokens(uint256 amount) external {
        require(amount > 0 && amount <= balanceOf(msg.sender), "Invalid amount");

        _burn(msg.sender, amount);
        _recordAction(msg.sender, Action.REDEEM, amount);
        emit TokensRedeemed(msg.sender, amount);
    }

    // Function to check a player's balance
    function checkBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }

    // Function to get a player's action history
    function getPlayerActions(address player) external view returns (GameAction[] memory) {
        return playerActions[player];
    }

    // Internal function to record a game action
    function _recordAction(address player, Action action, uint256 amount) internal {
        playerActions[player].push(GameAction({
            action: action,
            amount: amount
        }));
    }
}
