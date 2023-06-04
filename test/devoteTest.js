// test.js

const { expect } = require("chai");

describe("DecentralizedVoting", function () {
  let DecentralizedVoting;
  let decentralizedVoting;
  let owner;
  let addr1;

  beforeEach(async function () {
    DecentralizedVoting = await ethers.getContractFactory(
      "DecentralizedVoting"
    );
    [owner, addr1] = await ethers.getSigners();

    decentralizedVoting = await DecentralizedVoting.deploy();
    await decentralizedVoting.deployed();
  });

  it("should create a voting instance with only the duration specified", async function () {
    const instanceName = "Test Instance";
    const instanceDuration = 3600; // 1 hour

    await decentralizedVoting.createInstance(instanceName, instanceDuration);

    const allInstances = await decentralizedVoting.getAllInstances();
    const createdInstance = allInstances[0];

    expect(createdInstance.name).to.equal(instanceName);
    expect(createdInstance.creator).to.equal(owner.address);
    expect(createdInstance.candidateCount).to.equal(0);
    expect(createdInstance.isOpen).to.be.true;

    const startTime = createdInstance.startTime.toNumber();
    const endTime = createdInstance.endTime.toNumber();

    // Check if the start time is within a reasonable range
    const currentTime = Math.floor(Date.now() / 1000);
    expect(startTime).to.be.closeTo(currentTime, 5);

    // Check if the end time is correct based on the duration
    expect(endTime).to.equal(startTime + instanceDuration);
  });
});
