// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/EscrowFactory.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        EscrowFactory factory = new EscrowFactory();
        
        console.log("EscrowFactory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
