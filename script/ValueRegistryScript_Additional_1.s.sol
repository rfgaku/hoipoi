// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol"; // コントラクトのインポート

contract ValueRegistryScript_Additional_1 is Script {
    function setUp() public {}

    function run() public {
        // 1. デプロイしたコントラクトのアドレスを設定
        address valueRegistryAddress = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512; // 実際のデプロイアドレスを設定

        // 2. コントラクトのインスタンスを作成
        ValueRegistry valueRegistry = ValueRegistry(valueRegistryAddress);

        // 3. トランザクションを開始
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // デプロイ時の秘密鍵
        vm.startBroadcast(deployerPrivateKey);

        // 4. 同じ VIN No. に複数の事故記録を追加（タイムスタンプをずらす）
        uint256 vin1 = 123456789;
        valueRegistry.setValue(vin1, 1); // VIN 123456789 に事故あり（1回目）

        vm.warp(block.timestamp + 60); // タイムスタンプを1分進める
        valueRegistry.setValue(vin1, 2); // VIN 123456789 に事故あり（2回目）

        vm.warp(block.timestamp + 120); // さらに2分進める
        valueRegistry.setValue(vin1, 3); // VIN 123456789 に事故あり（3回目）

        // トランザクションを終了
        vm.stopBroadcast();

        // 5. getAccidentRecords で事故記録（値 + タイムスタンプ）を取得
        ValueRegistry.AccidentRecord[] memory records = valueRegistry.getAccidentRecords(vin1);
        console.log("Accident records with timestamps for VIN 123456789:");
        for (uint256 i = 0; i < records.length; i++) {
            console.log("Value:", records[i].value);
            console.log("Timestamp:", records[i].timestamp);
        }

        // 6. 別のEOA（秘密鍵）で setValue を試す
        uint256 attackerPrivateKey = 0xABCDEF1234567890ABCDEF1234567890ABCDEF1234567890ABCDEF1234567890; // 仮の秘密鍵
        vm.startBroadcast(attackerPrivateKey);

        try valueRegistry.setValue(vin1, 4) {
            console.log("ERROR: Unauthorized account succeeded in setting a value.");
        } catch {
            console.log("SUCCESS: Unauthorized account failed to set a value.");
        }

        // トランザクションを終了
        vm.stopBroadcast();

        //forge script script/ValueRegistryScript_Additional_1.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
        //でコマンド実行
    }
}
