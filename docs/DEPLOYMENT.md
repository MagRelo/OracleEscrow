# Deployment Guide

## Prerequisites

### Environment Setup

1. **Install Foundry**
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. **Set up environment variables**
   ```bash
   export PRIVATE_KEY=your_private_key_here
   export BASE_SEPOLIA_RPC_URL=your_rpc_url_here
   export BASESCAN_API_KEY=your_etherscan_api_key_here
   ```

3. **Create `.env` file**
   ```env
   PRIVATE_KEY=your_private_key_here
   BASE_SEPOLIA_RPC_URL=your_rpc_url_here
   BASESCAN_API_KEY=your_etherscan_api_key_here
   ```

### Network Configuration

#### Base Sepolia (Testnet)
- **Chain ID**: 84532
- **RPC URL**: https://sepolia.base.org
- **Explorer**: https://sepolia.basescan.org

#### Base Mainnet
- **Chain ID**: 8453
- **RPC URL**: https://mainnet.base.org
- **Explorer**: https://basescan.org

## Deployment Steps

### 1. Build Contracts

```bash
# Build all contracts
forge build

# Verify build was successful
forge build --sizes
```

### 2. Run Tests

```bash
# Run all tests
forge test

# Run with verbose output
forge test -vvv

# Run with gas reporting
forge test --gas-report
```

### 3. Deploy to Testnet

```bash
# Deploy to Base Sepolia
forge script script/Deploy.s.sol \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $BASESCAN_API_KEY

# Or use .env file
forge script script/Deploy.s.sol \
  --rpc-url $BASE_SEPOLIA_RPC_URL \
  --broadcast \
  --verify
```

### 4. Deploy to Mainnet

```bash
# Deploy to Base Mainnet
forge script script/Deploy.s.sol \
  --rpc-url https://mainnet.base.org \
  --broadcast \
  --verify \
  --etherscan-api-key $BASESCAN_API_KEY
```

## Deployment Verification

### 1. Check Deployment

After deployment, you should see output like:
```
EscrowFactory deployed at: 0x...
```

### 2. Verify on Explorer

1. Go to the appropriate explorer (Base Sepolia or Base Mainnet)
2. Search for the deployed contract address
3. Verify the contract source code matches

### 3. Test Deployment

```solidity
// Test the deployed factory
EscrowFactory factory = EscrowFactory(deployedAddress);

// Create a test escrow
address escrow = factory.createEscrow(
    1000 * 1e6,        // 1000 USDC
    block.timestamp + 1 hours,
    usdcAddress,       // USDC contract address
    6,                 // USDC decimals
    oracleAddress,     // Your oracle address
    500               // 5% oracle fee
);
```

## Post-Deployment Setup

### 1. Oracle Configuration

Set up your oracle addresses:
- Ensure oracle has sufficient gas for transactions
- Test oracle functions on testnet first
- Monitor oracle performance

### 2. Payment Token Setup

For each payment token you want to support:
- Verify the token contract address
- Test deposits and withdrawals
- Ensure proper decimal handling

### 3. Monitoring

Set up monitoring for:
- Contract events
- Gas usage
- Failed transactions
- Oracle activity

## Security Checklist

- [ ] Contracts deployed to testnet first
- [ ] All tests passing
- [ ] Contracts verified on explorer
- [ ] Oracle addresses configured correctly
- [ ] Payment token addresses verified
- [ ] Gas limits appropriate for operations
- [ ] Monitoring and alerting set up
- [ ] Emergency procedures documented

## Troubleshooting

### Common Issues

1. **Insufficient Gas**
   ```bash
   # Increase gas limit
   forge script script/Deploy.s.sol --gas-limit 5000000
   ```

2. **Verification Failed**
   ```bash
   # Check compiler version matches
   forge build --force
   ```

3. **RPC Issues**
   ```bash
   # Use alternative RPC
   forge script script/Deploy.s.sol --rpc-url https://alternative-rpc.com
   ```

### Support

For deployment issues:
1. Check the logs for specific error messages
2. Verify environment variables are set correctly
3. Ensure sufficient funds for deployment
4. Check network connectivity
