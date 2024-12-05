'use client'

import { useState, useEffect } from 'react'
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { accidentHistoryService, type AccidentRecord } from '@/services/accident-history'

export default function VehicleSearch() {
  const [vehicleId, setVehicleId] = useState('')
  const [searchResults, setSearchResults] = useState<{
    accidents: AccidentRecord[]
  } | null>(null)
  const [inputLabel, setInputLabel] = useState('Search with VEHICLE IDENTICATION NUMBER')

  useEffect(() => {
    const timer = setInterval(() => {
      setInputLabel(prev =>
        prev === 'Search with VEHICLE IDENTICATION NUMBER'
          ? '車体番号を入力してください'
          : 'Search with VEHICLE IDENTICATION NUMBER'
      )
    }, 3000)

    return () => clearInterval(timer)
  }, [])

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault()

    try {
      const vinNumber = parseInt(vehicleId)
      if (isNaN(vinNumber)) {
        alert('Please enter a valid VIN number')
        return
      }

      const accidents = await accidentHistoryService.getAccidentRecords(vinNumber)
      setSearchResults({ accidents })
    } catch (error) {
      console.error('Search failed:', error)
      alert('Failed to fetch accident records')
    }
  }

  return (
    <div className="min-h-screen bg-black text-amber-400 flex flex-col items-center justify-center p-4 font-mono">
      <style jsx global>{`
        @font-face {
          font-family: 'Press Start 2P';
          src: url('https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap');
        }
      `}</style>

      <h1 className="text-blue-400 mb-8 tracking-wide font-['Press_Start_2P'] text-center leading-relaxed">
  <span className="text-5xl block mb-2 tracking-widest" style={{ textShadow: '3px 3px 0px #000000' }}>HOIPOI</span>
  <span className="text-3xl block tracking-[0.5em]" style={{ textShadow: '2px 2px 0px #000000' }}>CHAIN</span>
</h1>

      <div className="w-full max-w-md space-y-8">
        <form onSubmit={handleSearch} className="space-y-4">
          <div className="space-y-2">
            <label className="block text-center text-lg h-16">
              {inputLabel}
            </label>
            <div className="relative">
              <span className="absolute left-3 top-1/2 transform -translate-y-1/2 text-blue-400">VIN.</span>
              <Input
                type="text"
                value={vehicleId}
                onChange={(e) => setVehicleId(e.target.value)}
                className="bg-blue-950 border-blue-400 text-amber-400 text-center tracking-wider pl-12"
                style={{ fontFamily: 'Press Start 2P' }}
              />
            </div>
          </div>

          <Button 
            type="submit"
            className="w-full bg-blue-600 hover:bg-blue-700 text-white font-['Press_Start_2P'] tracking-wider py-6"
          >
            SEARCH
          </Button>
        </form>

        {searchResults && (
          <div className="mt-8 space-y-4 border-2 border-blue-400 p-4">
            <h2 className="text-center text-lg mb-4">ACCIDENT HISTORY</h2>
            <div className="text-center mb-4">
              TOTAL ACCIDENTS: {searchResults.accidents.length}
            </div>
            {searchResults.accidents.map((accident, index) => (
              <div
                key={index}
                className="border border-blue-400 p-3 text-sm space-y-2"
              >
                <div className="text-blue-400">DATE: {accident.timestamp}</div>
                <div>{accident.value}</div>
              </div>
            ))}
          </div>
        )}
      </div>

      <footer className="mt-8 text-xs text-center">
        © 2024 VEHICLE DATABASE
        <br />
        powered by capsule
      </footer>
    </div>
  )
}

