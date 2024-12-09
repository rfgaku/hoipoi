'use client'

import { useAccount, useChainId } from 'wagmi'

export function NetworkStatus() {
  const { address, isConnected } = useAccount()
  const chainId = useChainId()

  // チェーンIDから名前を取得する関数
  const getChainName = (id: number) => {
    switch (id) {
      case 31337:
        return 'Anvil'
      case 1337:
        return 'Localhost'
      default:
        return `Chain ID: ${id}`
    }
  }

  return (
    <div className="text-sm text-blue-400 mb-4">
      <div>Connection Status: {isConnected ? '接続済み' : '未接続'}</div>
      {isConnected && (
        <>
          <div>Network: {getChainName(chainId)}</div>
          <div>Address: {address}</div>
        </>
      )}
    </div>
  )
} 