# Contracts Summary

## Overview

This repository contains smart contracts for a flexible escrow system that allows participants to deposit tokens and receive payouts based on oracle-determined results.

## Contract Details

### Escrow.sol

**Purpose**: Main escrow contract that manages deposits, withdrawals, and payout distribution.

**Key Features**:

- Fixed deposit amounts per participant
- Oracle-controlled payout distribution using basis points
- Automatic oracle fee collection
- Expiry-based refund mechanism
- Emergency cancellation support
- Gas-optimized participant management

**State Machine**:

1. `OPEN` - Participants can deposit and withdraw
2. `IN_PROGRESS` - Deposits closed, oracle can distribute payouts
3. `SETTLED` - Payouts distributed, escrow complete
4. `CANCELLED` - Escrow cancelled, all participants refunded

**Key Functions**:

- `deposit()` - Deposit required amount
- `withdraw()` - Withdraw deposit before escrow proceeds
- `closeDeposits()` - Oracle closes deposits
- `distribute(uint256[] calldata _payoutBasisPoints)` - Oracle distributes payouts
- `cancelAndRefund()` - Oracle cancels escrow
- `expiredEscrowWithdraw()` - Withdraw after expiry

### EscrowFactory.sol

**Purpose**: Factory contract for creating escrow instances with consistent configuration.

**Key Features**:

- Creates escrow contracts with flexible parameters
- Maintains registry of all created escrows
- Supports different payment tokens per escrow

**Key Functions**:

- `createEscrow(...)` - Creates new escrow contract
- `getEscrows()` - Returns all created escrows

### MockUSDC.sol

**Purpose**: Mock USDC token for testing purposes.

**Key Features**:

- 6 decimal places (like real USDC)
- Mint and burn functions for testing
- ERC20 standard compliance

## Security Considerations

### Access Control

- Oracle-only functions: `closeDeposits()`, `distribute()`, `cancelAndRefund()`
- Participant functions: `deposit()`, `withdraw()`, `expiredEscrowWithdraw()`

### Reentrancy Protection

- All external calls use `nonReentrant` modifier
- State changes before external calls (checks-effects-interactions pattern)

### Input Validation

- Deposit amount must be > 0
- Expiry must be in the future
- Payment token and oracle cannot be zero addresses
- Oracle fee cannot exceed 100% (10000 basis points)
- Payout basis points must total exactly 10000

### Gas Optimization

- Maximum 2000 participants per escrow
- O(1) participant removal using index mapping
- Efficient payout distribution algorithm

## Integration Guide

### Creating an Escrow

```solidity
// 1. Deploy factory
EscrowFactory factory = new EscrowFactory();

// 2. Create escrow
address escrowAddress = factory.createEscrow(
    depositAmount,
    expiry,
    paymentToken,
    paymentTokenDecimals,
    oracle,
    oracleFee
);
```

### Using an Escrow

```solidity
Escrow escrow = Escrow(escrowAddress);

// Participant deposits
paymentToken.approve(address(escrow), depositAmount);
escrow.deposit();

// Oracle closes deposits
escrow.closeDeposits();

// Oracle distributes payouts
uint256[] memory payouts = new uint256[](participantCount);
// Set payout basis points for each participant
escrow.distribute(payouts);
```

## Testing Strategy

### Unit Tests

- Constructor validation
- Deposit/withdraw functionality
- State transitions
- Access control
- Input validation

### Integration Tests

- Complete escrow flow
- Multiple participants
- Different payment tokens
- Oracle fee calculations

### Edge Cases

- Maximum participants
- Large amounts
- Gas optimization
- Reentrancy protection

## Deployment Checklist

- [ ] Deploy EscrowFactory
- [ ] Verify contract on Etherscan
- [ ] Set up oracle addresses
- [ ] Test with mock tokens
- [ ] Deploy to mainnet with real tokens
- [ ] Monitor gas usage
- [ ] Set up monitoring and alerts
