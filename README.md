# FundMe - Ethereum Crowdfunding Contract

A decentralized crowdfunding smart contract built with Foundry that allows users to fund projects with ETH. The contract uses Chainlink Price Feeds to ensure minimum USD contribution requirements.

## Features

- **Minimum Contribution**: Enforces a minimum contribution of $5 USD (in ETH)
- **Price Oracle Integration**: Uses Chainlink Price Feeds for real-time ETH/USD conversion
- **Owner Withdrawal**: Contract owner can withdraw all funds
- **Gas Optimized**: Includes both standard and gas-optimized withdrawal functions
- **Multi-Network Support**: Configured for Sepolia testnet and local Anvil networks
- **Comprehensive Testing**: Unit tests and integration tests included

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Node.js (for dependencies)
- An Ethereum wallet with testnet ETH (for deployment)

## Installation

1. Clone the repository:
```shell
git clone <repository-url>
cd foundry-fund-me
```

2. Install dependencies:
```shell
forge install
```

3. Create a `.env` file in the root directory and add the following environment variables:
```shell
# Sepolia Testnet RPC URL (get from Alchemy, Infura, or other providers)
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID

# Your private key (without 0x prefix, or with it - both work)
# WARNING: Never commit this file to version control!
PRIVATE_KEY=your_private_key_here

# Etherscan API Key (for contract verification)
# Get your API key from https://etherscan.io/apis
ETHERSCAN_API_KEY=your_etherscan_api_key_here

# Optional: For general RPC URL usage
RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
```

**Important Notes:**
- Replace `YOUR_PROJECT_ID` with your actual RPC provider project ID
- Replace `your_private_key_here` with your wallet's private key
- Replace `your_etherscan_api_key_here` with your Etherscan API key
- Make sure `.env` is in your `.gitignore` file to prevent committing sensitive information
- For local development with Anvil, you can use the default private key: `0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`

## Project Structure

```
foundry-fund-me/
├── src/
│   ├── FundMe.sol          # Main crowdfunding contract
│   └── PriceConverter.sol  # Library for ETH/USD price conversion
├── script/
│   ├── DeployFundMe.s.sol  # Deployment script
│   ├── HelperConfig.s.sol  # Network configuration helper
│   └── Interactions.s.sol  # Interaction scripts (fund/withdraw)
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol    # Unit tests
│   ├── integration/
│   │   └── InteractionsTest.t.sol  # Integration tests
│   └── mocks/
│       └── MockV3Aggregator.sol    # Mock price feed for local testing
└── foundry.toml            # Foundry configuration
```

## Usage

### Build

Compile the contracts:
```shell
forge build
```

### Test

Run all tests:
```shell
forge test
```

Run tests with verbosity:
```shell
forge test -vvv
```

### Format

Format the code:
```shell
forge fmt
```

### Gas Snapshots

Generate gas usage snapshots:
```shell
forge snapshot
```

### Local Development

Start a local Anvil node:
```shell
anvil
```

### Deploy

Deploy to Sepolia testnet:
```shell
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

Deploy to local Anvil:
```shell
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
```

### Interact with Deployed Contract

Fund the contract:
```shell
forge script script/Interactions.s.sol:FundFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

Withdraw funds (owner only):
```shell
forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

## Contract Details

### FundMe Contract

**Key Functions:**
- `fund()`: Allows users to contribute ETH (minimum $5 USD)
- `withdraw()`: Owner can withdraw all funds
- `cheaperWithdraw()`: Gas-optimized withdrawal function
- `getAddressToAmountFounded(address)`: Get contribution amount for an address
- `getFounder(uint256)`: Get founder address by index
- `getOwner()`: Get contract owner address

**Constants:**
- `MINIMUM_USD`: Minimum contribution amount (5e18 = $5 USD)

### PriceConverter Library

Converts ETH amounts to USD using Chainlink Price Feeds:
- `getPrice()`: Gets current ETH price in USD
- `getConversionRate()`: Converts ETH amount to USD value

## Testing

The project includes comprehensive test coverage:

- **Unit Tests**: Test individual contract functions
- **Integration Tests**: Test contract interactions
- **Mock Contracts**: Mock Chainlink Price Feed for local testing

Run specific test:
```shell
forge test --match-test testFundUpdatesFundedDataStruct
```

## Network Configuration

The contract automatically detects the network:
- **Sepolia Testnet** (Chain ID: 11155111): Uses Chainlink Sepolia Price Feed
- **Local Anvil**: Deploys a mock price feed for testing

## Dependencies

- [forge-std](https://github.com/foundry-rs/forge-std): Foundry standard library
- [chainlink-brownie-contracts](https://github.com/smartcontractkit/chainlink-brownie-contracts): Chainlink contracts
- [foundry-devops](https://github.com/Cyfrin/foundry-devops): DevOps utilities

## License

MIT
