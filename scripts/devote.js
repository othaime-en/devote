const { ethers } = require("hardhat");

async function main() {
  // Deploying the DecentralizedVoting contract
  const DecentralizedVoting = await ethers.getContractFactory(
    "DecentralizedVoting"
  );
  const votingContract = await DecentralizedVoting.deploy();
  await votingContract.deployed();
  console.log("DecentralizedVoting contract deployed:", votingContract.address);

  // Creating a voting instance
  await votingContract.createInstance("Example Voting Instance");
  console.log("Voting instance created");

  await votingContract.createInstance("Example Voting Instance 2");
  console.log("Voting instance created");

  // Adding candidates to the voting instance
  await votingContract.addCandidate(1, "Candidate A", "Role A", "Party A");
  await votingContract.addCandidate(1, "Candidate B", "Role B", "Party B");
  console.log("Candidates added");

  console.log(
    "The open instances are: ",
    await votingContract.getOpenInstances()
  );

  // Casting votes
  await votingContract.vote(1, 1);
  await votingContract.vote(1, 2);
  await votingContract.vote(1, 2);
  console.log("Votes casted");

  // Getting the overall results
  const [candidateIds, candidateNames, voteCounts] =
    await votingContract.getOverallResults(1);

  console.log("Voting Results:");
  for (let i = 0; i < candidateIds.length; i++) {
    console.log(
      `${candidateNames[i]} (ID: ${candidateIds[i]}) - Votes: ${voteCounts[i]}`
    );
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
