// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_AnchoredSwap_Module = buildModule("YDC_AnchoredSwap", (m) => {
  const ydcAnchoredSwap = m.contract("YDC_AnchoredSwap");
  return { ydcAnchoredSwap };
});

export default YDC_AnchoredSwap_Module;
