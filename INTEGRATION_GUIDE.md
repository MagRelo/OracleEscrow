# Integration Guide

This guide explains how to integrate the escrow contracts into your main project.

## Current Status

✅ **Completed:**
- Extracted Escrow and EscrowFactory contracts to separate repository
- All tests passing (57 tests total)
- Comprehensive documentation created
- Foundry dependencies installed
- Git repository initialized and committed

## Next Steps for Integration

### Option 1: Git Submodule (Recommended)

1. **Add as submodule to your main project:**
   ```bash
   cd /path/to/your/main/project
   git submodule add <escrow-repo-url> contracts/escrow-contracts
   git submodule update --init --recursive
   ```

2. **Update your main project's foundry.toml:**
   ```toml
   [profile.default]
   src = "src"
   out = "out"
   libs = ["lib", "contracts/escrow-contracts/lib"]
   solc_version = "0.8.20"
   ```

3. **Update remappings.txt:**
   ```
   @cut/escrow-contracts/=contracts/escrow-contracts/src/
   @openzeppelin/=contracts/escrow-contracts/lib/openzeppelin-contracts/
   forge-std/=contracts/escrow-contracts/lib/forge-std/src/
   ```

4. **Update import statements in your main project:**
   ```solidity
   // Before
   import "./Escrow.sol";
   import "./EscrowFactory.sol";
   
   // After
   import "@cut/escrow-contracts/Escrow.sol";
   import "@cut/escrow-contracts/EscrowFactory.sol";
   ```

### Option 2: NPM Package

1. **Publish to npm:**
   ```bash
   cd escrow-contracts
   npm publish
   ```

2. **Install in main project:**
   ```bash
   npm install @cut/escrow-contracts
   ```

3. **Update remappings.txt:**
   ```
   @cut/escrow-contracts/=node_modules/@cut/escrow-contracts/src/
   ```

### Option 3: Direct Copy (Not Recommended)

If you prefer to keep the contracts in your main project:

1. **Remove the original contracts:**
   ```bash
   rm contracts/src/Escrow.sol
   rm contracts/src/EscrowFactory.sol
   rm contracts/src/mocks/MockUSDC.sol
   rm contracts/test/Escrow.t.sol
   rm contracts/test/EscrowFactory.t.sol
   ```

2. **Copy from the new repository:**
   ```bash
   cp escrow-contracts/src/* contracts/src/
   cp escrow-contracts/test/Escrow*.t.sol contracts/test/
   ```

## Testing Integration

After integration, verify everything works:

```bash
# Build the main project
forge build

# Run all tests
forge test

# Run specific escrow tests
forge test --match-contract EscrowTest
forge test --match-contract EscrowFactoryTest
```

## Deployment Integration

Update your deployment scripts to use the new contracts:

```solidity
// In your deployment script
import "@cut/escrow-contracts/EscrowFactory.sol";

contract DeployScript is Script {
    function run() external {
        // Deploy escrow factory
        EscrowFactory factory = new EscrowFactory();
        
        // Deploy other contracts that depend on escrow
        // ...
    }
}
```

## Benefits of This Approach

1. **Reusability**: Escrow contracts can be used in other projects
2. **Maintainability**: Easier to maintain and update escrow functionality
3. **Testing**: Dedicated test suite for escrow contracts
4. **Documentation**: Comprehensive documentation for the escrow system
5. **Versioning**: Proper semantic versioning for the escrow contracts
6. **Security**: Isolated security audits and reviews

## Troubleshooting

### Import Issues
If you encounter import errors:
1. Check that remappings.txt is correctly configured
2. Verify the path to the escrow contracts
3. Ensure all dependencies are installed

### Test Failures
If tests fail after integration:
1. Check that the escrow contracts are being imported correctly
2. Verify that mock contracts are available
3. Ensure test environment is properly set up

### Build Issues
If build fails:
1. Check foundry.toml configuration
2. Verify all dependencies are installed
3. Check for version conflicts

## Support

For integration issues:
1. Check the escrow contracts documentation
2. Review the test files for usage examples
3. Open an issue in the escrow contracts repository
