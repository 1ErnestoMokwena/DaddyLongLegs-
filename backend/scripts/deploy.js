async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with account:", deployer.address);

  const DLLToken = await ethers.getContractFactory("DLLToken");
  const dllToken = await DLLToken.deploy();

  await dllToken.deployed();
  console.log("DLLToken deployed to:", dllToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
