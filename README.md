# DeVote: A Decentralized Voting Application

Interacting with the DecentralizedVoting Contract using Hardhat

This guide will walk you through the steps to interact with the DecentralizedVoting smart contract in a Hardhat environment. You will be able to create voting instances, add candidates, cast votes, and retrieve voting results.

Prerequisites:

- Node.js (https://nodejs.org) installed on your machine.
- Basic knowledge of Solidity and Ethereum.

Getting Started:

1. Clone the repository:
   $ git clone <repository-url>
   $ cd <repository-folder>

2. Install dependencies:
   $ npm install

3. Set up the Hardhat environment:

   - Rename the `hardhat.example.config.js` file to `hardhat.config.js`.
   - Update the `hardhat.config.js` file with your preferred network configurations (e.g., local network, testnet, or mainnet).
   - If using a local network, make sure you have a local blockchain running (e.g., Ganache).

4. Compile the smart contracts:
   $ npx hardhat compile

5. Run the tests:
   $ npx hardhat test

Interacting with the Contract:

To interact with the DecentralizedVoting contract, you can create a JavaScript file in the `scripts` directory and use Hardhat's built-in console or write custom scripts.

Example script: `scripts/interact.js`

```javascript
// Import the ethers library
const { ethers } = require("hardhat");

async function main() {
  // Retrieve the contract instance
  const DecentralizedVoting = await ethers.getContractFactory(
    "DecentralizedVoting"
  );
  const votingContract = await DecentralizedVoting.deploy();

  // Deploy the contract
  await votingContract.deployed();
  console.log(
    "DecentralizedVoting contract deployed at:",
    votingContract.address
  );

  // Interact with the contract
  // ...

  // Run additional functions or tests
  // ...
}

// Execute the main function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
```

Running the script:

To run the script, execute the following command in your terminal:

```shell
$ npx hardhat run scripts/interact.js --network <network-name>
Replace <network-name> with the network you configured in the hardhat.config.js file (e.g., localhost for a local network).
```

You can modify the interact.js script to interact with the DecentralizedVoting contract using the available functions such as creating instances, adding candidates, casting votes, and retrieving voting results.

For more information on interacting with smart contracts using Hardhat, refer to the Hardhat documentation: https://hardhat.org/getting-started/#interacting-with-the-contract

Please note that the above README.txt file assumes you have set up a Hardhat environment, including installing the required dependencies and configuring the network settings in the `hardhat.config.js` file. Additionally, it provides an example script `scripts/interact.js` that you can use to interact with the DecentralizedVoting contract. You can modify the script according to your requirements and add more functions or tests as needed.
