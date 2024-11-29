// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol";

contract ValueRegistryScript_Additional_2 is Script {
    function setUp() public {}

    function run() public {
        // JSONファイルを読み込み
        string memory jsonData = vm.readFile("./script/vin_data.json");



        // 必要なデータをJSONからパース
        uint256[] memory vins = vm.parseJsonUintArray(jsonData, ".vin");
        uint256[] memory accidentValues = vm.parseJsonUintArray(jsonData, ".values");
        uint256[] memory timestamps = vm.parseJsonUintArray(jsonData, ".timestamps");

        // デプロイしたコントラクトのアドレスを設定
        address valueRegistryAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        ValueRegistry valueRegistry = ValueRegistry(valueRegistryAddress);

        // トランザクションを開始
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // JSONデータに基づいてデータを設定
        for (uint256 i = 0; i < vins.length; i++) {
            vm.warp(timestamps[i]); // タイムスタンプを進める
            valueRegistry.setValue(vins[i], accidentValues[i]); // VINと事故記録を設定
        }

        // トランザクションを終了
        vm.stopBroadcast();

        // 設定したデータを取得してログに出力
        console.log("Accident records from JSON data:");
        for (uint256 i = 0; i < vins.length; i++) {
            ValueRegistry.AccidentRecord[] memory records = valueRegistry.getAccidentRecords(vins[i]);
            console.log("VIN:", vins[i]);
            for (uint256 j = 0; j < records.length; j++) {
                console.log("  Value:", records[j].value);
                console.log("  Timestamp:", records[j].timestamp);
            }
        }

        // Unauthorized アクセスのテスト
        uint256 attackerPrivateKey = 0xABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890; // 仮の秘密鍵
        vm.startBroadcast(attackerPrivateKey);

        try valueRegistry.setValue(vins[0], 999) {
            console.log("ERROR: Unauthorized account succeeded in setting a value.");
        } catch {
            console.log("SUCCESS: Unauthorized account failed to set a value.");
        }

        // トランザクションを終了
        vm.stopBroadcast();

        //forge script script/ValueRegistryScript_Additional_2.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
        //でコマンド実行
    }
}
