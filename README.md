# DeVote: A Decentralized Voting Application

This project demonstrates a basic implementation of a voting application on a blockchain.

Here is the expected general flow of usage in the application

To interact with the contracts above vote, you need to follow these steps:

1. Deploy the `VotingInstance` contract on a network of your choice (e.g. testnet or mainnet).
2. Call the `createVoteInstance` function with a name and a number of options for your voting instance. For example, `createVoteInstance("Best Movie", 3)` will create a voting instance with the name "Best Movie" and three options.
3. Call the `addOption` function inherited from the Voting contract with the option name for each option index. For example, `addOption("The Matrix")` will add "The Matrix" as the option for index 0, `addOption("The Lord of the Rings")` will add "The Lord of the Rings" as the option for index 1, and `addOption("The Godfather")` will add "The Godfather" as the option for index 2.
4. To vote on an instance, call the `voteOnInstance` function with the name and the option index of your choice. For example, `voteOnInstance("Best Movie", 1)` will vote for "The Lord of the Rings" on the "Best Movie" instance.
5. To close a voting instance, call the `closeVoteInstance` function with the name of the instance. For example, `closeVoteInstance("Best Movie")` will close the "Best Movie" instance and prevent further voting.
6. To get the names of all current voting instances, call the `getInstanceNames` function. It will return an array of strings with the names of all instances.
7. To get the vote count for an option on an instance, call the `getVoteCount` function inherited from the Voting contract with the option name. For example, `getVoteCount("The Godfather")` will return the number of votes for "The Godfather" on any instance that has it as an option.
8. To get the option name by index on an instance, call the `getOption` function inherited from the Voting contract with the index. For example, `getOption(2)` will return "The Godfather" if it is the option for index 2 on any instance.

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
