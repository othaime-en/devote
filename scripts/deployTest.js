// scripts/deployTest.js

const hre = require("hardhat");

// async function main() {
//   // We get the contract to deploy
//   const VotingInstance = await hre.ethers.getContractFactory("VotingInstance");
//   const votingInstance = await VotingInstance.deploy();

//   await votingInstance.deployed();

//   console.log("Voting instance deployed to:", votingInstance.address);
//   console.log(
//     "The admin address for this application is:",
//     await votingInstance.admin()
//   );

//   console.log(
//     "The total number of votes is:",
//     await votingInstance.totalVotes()
//   );

//   await votingInstance.createVoteInstance("Presidential Election", 3);

//   await votingInstance.addOption(
//     ethers.utils.formatBytes32String("Donald Trump")
//   );
//   await votingInstance.addOption(ethers.utils.formatBytes32String("Joe Biden"));
//   await votingInstance.addOption(
//     ethers.utils.formatBytes32String("Kanye West")
//   );

//   await votingInstance.voteOnInstance("Presidential Election", 1);
//   const votecount = await votingInstance.getVoteCount(
//     ethers.utils.formatBytes32String("Joe Biden")
//   );

//   console.log("The total number of votes is:", votecount.toString());

//   console.log(
//     "The total instances are: ",
//     await votingInstance.getInstanceNames()
//   );

//   console.log(
//     "The total number of options is:",
//     await votingInstance.getOption(0)
//   );

//   /**
//    * Other pieces of code exist here
//    * * Important api calls
//    * * Any credentials in environment variables are also passed here
//    * * Any other deployment and frontend logic exists here and in other files in the scripts section.
//    */
// }

const { ethers } = require("hardhat");

async function main() {
  // Step 1: Deploy the Contracts
  const Voting = await ethers.getContractFactory("Voting");
  const votingContract = await Voting.deploy();
  await votingContract.deployed();
  console.log("Voting contract deployed at:", votingContract.address);

  const VotingInstance = await ethers.getContractFactory("VotingInstance");
  const votingInstanceContract = await VotingInstance.deploy();
  await votingInstanceContract.deployed();
  console.log(
    "VotingInstance contract deployed at:",
    votingInstanceContract.address
  );

  // Step 2: Initialize Voting Instances
  async function createVoteInstance(name, numOptions) {
    await votingInstanceContract.createVoteInstance(name, numOptions);
    console.log("Voting instance created:", name);
  }

  await createVoteInstance("VotingInstance1", 3);
  await createVoteInstance("VotingInstance2", 5);

  // Step 3: Add Options to Voting Instances
  async function addOption(instanceName, optionName) {
    const votingContractInstance = await Voting.attach(votingContract.address);
    await votingContractInstance.addOption(
      ethers.utils.formatBytes32String(optionName)
    );
    console.log("Option", optionName, "added to", instanceName);
  }

  await addOption("VotingInstance1", "Option1");
  await addOption("VotingInstance1", "Option2");
  await addOption("VotingInstance2", "OptionA");
  await addOption("VotingInstance2", "OptionB");
  await addOption("VotingInstance2", "OptionC");

  // Step 4: Vote on Voting Instances
  async function voteOnInstance(instanceName, optionIndex) {
    await votingInstanceContract.voteOnInstance(instanceName, optionIndex);
    console.log("Vote cast on", instanceName, "for option", optionIndex);
  }

  await voteOnInstance("VotingInstance1", 0); // Vote on option 0 for VotingInstance1
  await voteOnInstance("VotingInstance2", 2); // Vote on option 2 for VotingInstance2

  // Step 5: Close Voting Instance (Optional)
  async function closeVoteInstance(instanceName) {
    await votingInstanceContract.closeVoteInstance(instanceName);
    console.log("Voting instance", instanceName, "closed");
  }

  await closeVoteInstance("VotingInstance1");

  // Step 6: Retrieve Voting Instance Names and Vote Counts
  async function getInstanceNamesAndVoteCounts() {
    const instanceNames = await votingInstanceContract.getInstanceNames();
    console.log("Voting instance names:", instanceNames);

    const votingContractInstance = await Voting.attach(votingContract.address);
    for (const instanceName of instanceNames) {
      const instance = votingInstanceContract.voteInstances(instanceName);
      console.log("Vote counts for", instanceName + ":");
      for (let i = 0; i < instance.voteCount.length; i++) {
        const option = await votingContractInstance.getOption(i);
        console.log(
          "Option",
          option.toString(),
          ":",
          instance.voteCount[i].toString()
        );
      }
    }
  }

  await getInstanceNamesAndVoteCounts();
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// This pattern is used to use async/await and to handle any incoming errors during deployment
// main()
//   .then(() => process.exit(0))
//   .catch((error) => {
//     console.error(error);
//     process.exit(1);
//   });
