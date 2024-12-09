import { http, cookieStorage, createConfig, createStorage } from 'wagmi'
import { localhost } from 'wagmi/chains'
import { metaMask } from 'wagmi/connectors'

// anvilチェーンの設定を追加
const anvil = {
  id: 31337,
  name: 'Anvil',
  nativeCurrency: { name: 'Ethereum', symbol: 'ETH', decimals: 18 },
  rpcUrls: {
    default: { http: ['http://127.0.0.1:8545'] },
    public: { http: ['http://127.0.0.1:8545'] },
  }
}

export function getConfig() {
  return createConfig({
    chains: [anvil, localhost],
    connectors: [
      metaMask(),
    ],
    storage: createStorage({
      storage: cookieStorage,
    }),
    ssr: true,
    transports: {
      [anvil.id]: http(),
      [localhost.id]: http(),
    },
  })
}

declare module 'wagmi' {
  interface Register {
    config: ReturnType<typeof getConfig>
  }
}
