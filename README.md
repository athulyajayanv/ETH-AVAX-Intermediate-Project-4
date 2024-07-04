# METACRAFTERS ETH-AVAX INTERMEDIATE PROJECT 4

This Solidity program defines a custom ERC20 token contract for Degen Gaming that allows minting, burning, transferring, and tracking player actions.

## Description

This Solidity contract extends the ERC20 standard to create a custom token named 'Degen' with symbol 'DGN' with additional features like minting, burning, transferring, and owner-only functions. It tracks various game-related actions taken by players using the token, demonstrating the use of OpenZeppelin's ERC20 implementation along with ownership and burning extensions.

1. Constructor: 
The constructor initializes the contract with the name "Degen" and symbol "DGN". It also sets the initial owner of the contract to the address provided as the initialOwner.

2. mintTokens: 
The mintTokens function allows the contract owner to mint new tokens to a specified recipient. It records the action as a PLAY and emits the TokensEarned event.

3. transferTokens: 
The transferTokens function allows players to transfer tokens to another address. It ensures that the recipient's address is valid and that the sender has sufficient tokens. It records the transfer action for both the sender and recipient, and emits the TokensTransferred event.

4. burnTokens: 
The burnTokens function allows players to burn their own tokens. It checks that the amount to be burned is valid and within the balance of the sender. It records the burn action and emits the TokensBurned event.

5. redeemTokens: 
The redeemTokens function allows players to redeem their tokens by burning them. It ensures that the amount to be redeemed is valid and within the sender's balance. It records the redeem action and emits the TokensRedeemed event.

6. checkBalance: 
The checkBalance function returns the token balance of a specified account.

7. getPlayerActions: 
The getPlayerActions function returns the action history of a specified player.

8. _recordAction: 
The _recordAction function is an internal function that records a specified action and amount for a given player. It adds the action to the playerActions mapping.

9. enum Action: 
The Action enum defines various actions that can be performed in the game, such as PLAY, WIN, LOSE, PURCHASE, REDEEM, TRANSFER, BURN, and RECEIVE.

10. struct GameAction: 
The GameAction struct stores the details of a game action, including the type of action and the amount involved.

## Getting Started

### Executing program

1. To run this program, you can use Remix at https://remix.ethereum.org/.
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Save the file with a .sol extension.

```javascript
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
```
## Connecting MetaMask with Avalanche Fuji Network, 

1. Open MetaMask and click on the network dropdown at the top.
2. Select "Add Network" and fill in the following details:
Network Name: Avalanche Fuji C-Chain
New RPC URL: https://api.avax-test.network/ext/bc/C/rpc](https://api.avax-test.network/ext/bc/C/rpc

ChainID: 43113

Symbol: AVAX

4. Save and switch to the new network.
   
## To compile the code,

1. Go to the 'Solidity Compiler' tab on the left.
2. Set the Compiler to 0.8.26 or a compatible version, and click Compile.
   
## Once compiled,

1. Go to the 'Deploy & Run Transactions' tab on the left.
2. Ensure the Environment is set to "Injected Web3" to connect with metamask wallet, for a local test environment.
3. Enter the initial owner's address in the "initialOwner" field.
4. Click deploy.

After deploying, you can interact with the contract.

## Verifying Contract on Snowtrace

1. Go to https://testnet.snowtrace.io/.
2. Search for your contract address.
3. Complete the verification.

## Authors

Athulya Jayan V

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
