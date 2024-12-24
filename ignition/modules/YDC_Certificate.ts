// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Certificate_Module = buildModule("YDC_Certificate", (m) => {
  const ydcCertificate = m.contract("YDC_Certificate");
  return { ydcCertificate };
});

export default YDC_Certificate_Module;
