import { vars, type HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox-viem';
import { HDNodeWallet } from 'ethers';
import { parseEther } from 'viem';
import '@typechain/hardhat';
import '@nomicfoundation/hardhat-ethers';
import '@nomicfoundation/hardhat-chai-matchers';

const exposedGet = (varName: string, defaultValue?: string) => {
  return '';
};

const varsGet = (varName: string, defaultValue?: string) => {
  if (true) {
    return vars.get(varName, defaultValue);
  } else {
    return exposedGet(varName, defaultValue);
  }
};

const TEST_MNEMONIC = varsGet('TEST_MNEMONIC');
const ALCHEMY_API_KEY = varsGet('ALCHEMY_API_KEY');
const ETHERSCAN_API_KEY = varsGet('ETHERSCAN_API_KEY');

function getWalletFromMnemonic(mnemonic: string, index: number = 0) {
  const path = `m/44'/60'/0'/0/${index}`;
  const hdNode = HDNodeWallet.fromPhrase(mnemonic, undefined, path);
  return {
    index, path,
    privateKey: hdNode.privateKey,
    address: hdNode.address,
  };
}

const testAccounts = Array(100).fill(0).map((_, index) => getWalletFromMnemonic(TEST_MNEMONIC, index));

const config: HardhatUserConfig = {
  solidity: '0.8.28',
  networks: {
    hardhat: {
      accounts: testAccounts.map((account) => ({
        privateKey: account.privateKey,
        balance: parseEther('10000').toString(),
      })),
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [testAccounts[0].privateKey],
    },
  },
  etherscan: {
    apiKey: {
      sepolia: ETHERSCAN_API_KEY,
    },
  },
};

export default config;
