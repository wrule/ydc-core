// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Post_Module = buildModule("YDC_Post", (m) => {
  const ydcPost = m.contract("YDC_Post");
  return { ydcPost };
});

export default YDC_Post_Module;
