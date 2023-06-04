// deploy.js

async function main() {
  // Retrieve the contract factory and signer
  const DecentralizedVoting = await ethers.getContractFactory(
    "DecentralizedVoting"
  );
  const [deployer] = await ethers.getSigners();

  // Deploy the contract
  console.log("Deploying DecentralizedVoting contract...");
  const decentralizedVoting = await DecentralizedVoting.deploy();

  // Wait for the contract to be mined
  await decentralizedVoting.deployed();
  console.log(
    "DecentralizedVoting contract deployed to:",
    decentralizedVoting.address
  );

  // Create the first voting instance
  const instance1Name = "Instance 1";
  const instance1StartTime = Math.floor(Date.now() / 1000); // Current timestamp
  const instance1EndTime = instance1StartTime + 3600; // 1 hour from now
  await decentralizedVoting.createInstance(
    instance1Name,
    instance1StartTime,
    instance1EndTime
  );
  console.log(`Created a new voting instance: ${instance1Name}`);

  // Create the second voting instance
  const instance2Name = "Instance 2";
  const instance2StartTime = instance1EndTime; // Start right after the first instance ends
  const instance2EndTime = instance2StartTime + 7200; // 2 hours from the start time
  await decentralizedVoting.createInstance(
    instance2Name,
    instance2StartTime,
    instance2EndTime
  );
  console.log(`Created a new voting instance: ${instance2Name}`);

  // Retrieve and display all voting instances
  const allInstances = await decentralizedVoting.getAllInstances();
  console.log("All Voting Instances:");
  allInstances.forEach((instance) => {
    console.log(`Instance ID: ${instance.id}`);
    console.log(`Name: ${instance.name}`);
    console.log(`Creator: ${instance.creator}`);
    console.log(`Candidate Count: ${instance.candidateCount}`);
    console.log(`Is Open: ${instance.isOpen}`);
    console.log("---");
  });
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
