// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Token_Module = buildModule("YDC_Token", (m) => {
  const ydcToken = m.contract("YDC_Token");
  return { ydcToken };
});

export default YDC_Token_Module;
