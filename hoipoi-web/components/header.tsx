'use client'

import { ConnectWallet } from './connect-wallet'

export function Header() {
  return (
    <header className="p-4 border-b bg-black text-amber-400">
      <style jsx global>{`
        @font-face {
          font-family: 'Press Start 2P';
          src: url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        }
      `}</style>
      <div className="flex justify-between items-center max-w-7xl mx-auto font-['Press_Start_2P']">
        <h1 className="text-xl text-blue-400 font-['Press_Start_2P']" style={{ textShadow: '2px 2px 0px #000000' }}>
          HOIPOI
        </h1>
        <ConnectWallet />
      </div>
    </header>
  )
}