'use client'

import { useAccount, useConnect, useDisconnect } from 'wagmi'

export function Header() {
  const account = useAccount()
  const { connectors, connect } = useConnect()
  const { disconnect } = useDisconnect()

  return (
    <header className="p-4 border-b bg-black text-amber-400">
      <style jsx global>{`
        @font-face {
          font-family: 'Press Start 2P';
          src: url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        }
      `}</style>
      <div className="flex justify-between items-center max-w-7xl mx-auto font-['Press_Start_2P']">
        <div className="flex items-center gap-4">
          <h1 className="text-xl text-blue-400 font-['Press_Start_2P']" style={{ textShadow: '2px 2px 0px #000000' }}>HOIPOI</h1>
          {account.status === 'connected' && (
            <div className="text-sm text-gray-600">
              Address: {account.addresses?.[0]?.slice(0, 6)}...{account.addresses?.[0]?.slice(-4)}
            </div>
          )}
        </div>

        <div>
          {account.status === 'connected' ? (
            <button
              type="button"
              onClick={() => disconnect()}
              className="px-4 py-2 rounded bg-red-500 text-white"
            >
              Disconnect
            </button>
          ) : (
            connectors.map((connector) => (
              <button
                key={connector.uid}
                onClick={() => connect({ connector })}
                type="button"
                className="px-4 py-2 rounded bg-blue-500 text-white mr-2"
              >
                {connector.name}
              </button>
            ))
          )}
        </div>
      </div>
    </header>
  )
}