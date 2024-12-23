// This setup uses Hardhat Ignition to manage smart contract deployments.
// Learn more about it at https://hardhat.org/ignition

import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const YDC_Course_Module = buildModule("YDC_Course", (m) => {
  const ydcCourse = m.contract("YDC_Course");
  return { ydcCourse };
});

export default YDC_Course_Module;
