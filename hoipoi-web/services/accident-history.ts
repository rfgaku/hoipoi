import { ethers } from 'ethers'

const CONTRACT_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
const CONTRACT_ABI = [
  {
    "type": "constructor",
    "inputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "getAccidentCount",
    "inputs": [
      {
        "name": "vin",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getAccidentRecords",
    "inputs": [
      {
        "name": "vin",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "tuple[]",
        "internalType": "struct ValueRegistry.AccidentRecord[]",
        "components": [
          {
            "name": "value",
            "type": "uint256",
            "internalType": "uint256"
          },
          {
            "name": "timestamp",
            "type": "uint256",
            "internalType": "uint256"
          }
        ]
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getValue",
    "inputs": [
      {
        "name": "vin",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "setValue",
    "inputs": [
      {
        "name": "vin",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "value",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  }
]


export type AccidentRecord = {
  value: number
  timestamp: number
}

export class AccidentHistoryService {
  private contract: ethers.Contract | null = null
  private provider: ethers.Provider | null = null

  constructor() {
    if (typeof window !== 'undefined' && window.ethereum) {
      this.provider = new ethers.BrowserProvider(window.ethereum)
      this.contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, this.provider) as ethers.Contract & {
        getAccidentRecords: (vin: bigint) => Promise<any>
      }
    } else {
      console.error('MetaMask is not installed. Please install it to use this feature.')
    }
  }

  async getAccidentRecords(vin: number): Promise<AccidentRecord[]> {
    if (!this.contract) {
      throw new Error('Blockchain provider is not available.')
    }

    try {
      const vinBN = ethers.getBigInt(vin)
      console.log('Fetching records for VIN:', vinBN.toString())

      const value = await this.contract.getValue(vinBN)
      console.log('Value from contract:', value)

      const signer = await (this.provider as ethers.BrowserProvider).getSigner()
      const contractWithSigner = this.contract.connect(signer)

      const records = await contractWithSigner.getAccidentRecords(vinBN)
      console.log('Raw records:', records)

      if (!Array.isArray(records)) {
        console.log('Records is not an array:', records)
        return []
      }

      return records.map((record) => ({
        value: Number(record.value),
        timestamp: Number(record.timestamp)
      }))
    } catch (error) {
      console.error('Detailed error:', error)
      if (error instanceof Error) {
        throw new Error(`Failed to fetch accident records: ${error.message}`)
      }
      throw error
    }
  }
}

export const accidentHistoryService = new AccidentHistoryService()