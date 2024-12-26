// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_DAO_Module = buildModule("YDC_DAO", (m) => {
  const ydcDAO = m.contract("YDC_DAO");
  return { ydcDAO };
});

export default YDC_DAO_Module;
