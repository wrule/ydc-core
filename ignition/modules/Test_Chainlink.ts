// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const Test_Chainlink_Module = buildModule("Test_Chainlink", (m) => {
  const testChainlink = m.contract("Test_Chainlink");
  return { testChainlink };
});

export default Test_Chainlink_Module;
