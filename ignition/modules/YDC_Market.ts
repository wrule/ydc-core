// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Market_Module = buildModule("YDC_Market", (m) => {
  const ydcMarket = m.contract("YDC_Market");
  return { ydcMarket };
});

export default YDC_Market_Module;
