# Escrow Contracts

A collection of smart contracts for managing escrow functionality with flexible payment tokens and oracle-controlled payouts.

## Features

- Support for any ERC20 token as payment
- Oracle-controlled payout distribution using basis points
- Expiry-based refund mechanism

## Installation

```bash
# Clone the repository
git clone <repository-url>
cd escrow-contracts

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

## Usage

### Creating an Escrow

```solidity
import "@cut/escrow-contracts/src/EscrowFactory.sol";

EscrowFactory factory = EscrowFactory(factoryAddress);

address escrow = factory.createEscrow(
    1000 * 1e6,        // depositAmount (1000 USDC)
    block.timestamp + 1 hours, // expiry
    usdcAddress,       // paymentToken
    6,                 // paymentTokenDecimals
    oracleAddress,     // oracle
    500               // oracleFee (5% = 500 basis points)
);
```

### Depositing into an Escrow

```solidity
import "@cut/escrow-contracts/src/Escrow.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

Escrow escrow = Escrow(escrowAddress);

// Get escrow details (deposit amount and expiry)
(uint256 depositAmount, uint256 expiry) = escrow.details();

// Get payment token address
IERC20 paymentToken = escrow.paymentToken();

// Approve tokens first (using the deposit amount from escrow details)
paymentToken.approve(address(escrow), depositAmount);

// Deposit
escrow.deposit();
```

### Distributing Payouts (Oracle Only)

```solidity
// Close deposits first
escrow.closeDeposits();

// Distribute payouts (basis points: 10000 = 100%)
uint256[] memory payouts = new uint256[](3);
payouts[0] = 6000; // 60% to first participant
payouts[1] = 2500; // 25% to second participant
payouts[2] = 1500; // 15% to third participant

escrow.distribute(payouts);
```

## Contract Architecture

### Escrow Contract

The main escrow contract that handles:

- Participant deposits and withdrawals
- Oracle-controlled payout distribution
- Expiry-based refunds
- Emergency cancellation

**Key Functions:**

- `deposit()` - Deposit the required amount
- `withdraw()` - Withdraw deposit before escrow proceeds
- `closeDeposits()` - Oracle closes deposits (moves to IN_PROGRESS)
- `distribute(uint256[] calldata _payoutBasisPoints)` - Oracle distributes payouts
- `cancelAndRefund()` - Oracle cancels escrow and refunds all
- `expiredEscrowWithdraw()` - Withdraw after expiry

### EscrowFactory Contract

Factory contract for creating escrow instances with consistent configuration.

**Key Functions:**

- `createEscrow(...)` - Creates a new escrow contract
- `getEscrows()` - Returns all created escrows

## Testing

```bash
# Run all tests
forge test

# Run specific test
forge test --match-test testDeposit

# Run with verbose output
forge test -vvv

# Run with gas reporting
forge test --gas-report
```

## Deployment

### Prerequisites

1. Set up environment variables:

```bash
export PRIVATE_KEY=your_private_key
export BASE_SEPOLIA_RPC_URL=your_rpc_url
export BASESCAN_API_KEY=your_etherscan_api_key
```

2. Create `.env` file:

```env
PRIVATE_KEY=your_private_key
BASE_SEPOLIA_RPC_URL=your_rpc_url
BASESCAN_API_KEY=your_etherscan_api_key
```

### Deploy

```bash
# Deploy to Base Sepolia
forge script script/Deploy.s.sol --rpc-url $BASE_SEPOLIA_RPC_URL --broadcast --verify

# Deploy to local network
forge script script/Deploy.s.sol --fork-url $BASE_SEPOLIA_RPC_URL --broadcast
```

## Security

### Audited Dependencies

- OpenZeppelin Contracts v5.4.0
- Foundry Standard Library v1.10.0

### Security Features

- Reentrancy protection using OpenZeppelin's ReentrancyGuard
- Comprehensive input validation
- Oracle-only access control for critical functions
- Expiry-based safety mechanisms
- Emergency cancellation support

### Known Limitations

- Maximum 2000 participants per escrow (gas optimization)
- Oracle fee cannot exceed 100% (10000 basis points)
- Expiry must be in the future

## Gas Optimization

- O(1) participant removal using index mapping
- Efficient payout distribution algorithm
- Minimal storage operations
- Optimized for up to 2000 participants

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## Support

For questions and support:

- Open an issue on GitHub
- Check the documentation in the `docs/` folder
- Review the test files for usage examples
