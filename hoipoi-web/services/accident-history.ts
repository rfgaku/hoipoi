import { useReadContract } from 'wagmi'
import { parseAbi } from 'viem'

const CONTRACT_ADDRESS = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
const CONTRACT_ABI = parseAbi([
  'function setValue(uint256 vin, uint256 value) public',
  'function getAccidentRecords(uint256 vin) public view returns ((uint256,uint256)[])',
  'function getAccidentCount(uint256 vin) public view returns (uint256)'
])

export type AccidentRecord = {
  value: number
  timestamp: number
}

export function useAccidentHistory(vin: number) {
  const { data, error, status, fetchStatus } = useReadContract({
    address: CONTRACT_ADDRESS,
    abi: CONTRACT_ABI,
    functionName: 'getAccidentRecords',
    args: [BigInt(vin)],
    chainId: 31337,
  })

  console.log('Contract Request:', {
    address: CONTRACT_ADDRESS,
    functionName: 'getAccidentRecords',
    args: [BigInt(vin)],
    argValue: Number(BigInt(vin)),
    chainId: 31337
  })

  console.log('Contract Response:', {
    status,
    fetchStatus,
    error: error?.message,
    data,
    dataType: data ? typeof data : 'undefined',
    isArray: Array.isArray(data),
    chainConnection: window?.ethereum?.isConnected?.()
  })

  const records = data?.map((record: readonly [bigint, bigint]) => ({
    value: Number(record[0]),
    timestamp: Number(record[1])
  })) ?? []

  return { records }
}
