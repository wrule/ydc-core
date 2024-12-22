// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Router_Module = buildModule("YDC_Router", (m) => {
  const ydcRouter = m.contract("YDC_Router");
  return { ydcRouter };
});

export default YDC_Router_Module;
