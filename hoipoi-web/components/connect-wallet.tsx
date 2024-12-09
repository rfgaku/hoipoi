'use client'

import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { useState } from 'react'

export function ConnectWallet() {
  const { address, isConnected } = useAccount()
  const { connect, connectors, isPending } = useConnect()
  const { disconnect } = useDisconnect()
  const [isConnecting, setIsConnecting] = useState(false)

  const handleConnect = async () => {
    if (isConnecting || isPending) return
    setIsConnecting(true)
    try {
      await connect({ connector: connectors[0] })
    } catch (error) {
      console.error('Connection error:', error)
    } finally {
      setIsConnecting(false)
    }
  }

  return (
    <div className="flex items-center gap-4">
      {isConnected ? (
        <div className="flex items-center gap-4">
          <span className="text-sm text-blue-400">
            {address?.slice(0, 6)}...{address?.slice(-4)}
          </span>
          <button
            onClick={() => disconnect()}
            className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-['Press_Start_2P'] text-sm tracking-wider rounded"
            disabled={isPending}
          >
            Disconnect
          </button>
        </div>
      ) : (
        <button
          onClick={handleConnect}
          disabled={isConnecting || isPending}
          className={`px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white font-['Press_Start_2P'] text-sm tracking-wider rounded ${
            (isConnecting || isPending) ? 'opacity-50 cursor-not-allowed' : ''
          }`}
        >
          {isConnecting || isPending ? 'Connecting...' : 'Connect MetaMask'}
        </button>
      )}
    </div>
  )
} 