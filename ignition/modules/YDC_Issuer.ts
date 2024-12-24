// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Issuer_Module = buildModule("YDC_Issuer", (m) => {
  const ydcIssuer = m.contract("YDC_Issuer");
  return { ydcIssuer };
});

export default YDC_Issuer_Module;
