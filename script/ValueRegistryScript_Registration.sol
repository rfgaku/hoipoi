// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol"; // コントラクトのインポート

contract ValueRegistryScript_Additional_1 is Script {
    function setUp() public {}

    function run() public { // run関数 はスクリプト全体の流れを管理する本体部分。Forgeのscriptを実行するとこのrun関数が最初に呼び出される
        // 1. 実際にデプロイしたコントラクトのアドレスを設定
        // スマートコントラクトがデプロイされたアドレスを指定
        address valueRegistryAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3; // 実際のデプロイアドレス

        // 2. コントラクトのインスタンスを作成
        // デプロイ済みのValueRegistryコントラクトの操作インターフェースを取得
        ValueRegistry valueRegistry = ValueRegistry(valueRegistryAddress);

        // 3. トランザクションを開始
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // デプロイ時の秘密鍵を環境変数から取得
        vm.startBroadcast(deployerPrivateKey); // 秘密鍵を使って以降の操作をトランザクションとして実行

        // 4. 同じ VIN No. に複数の事故記録を追加（タイムスタンプをずらす）
        uint256 vin1 = 123456789; // VIN No.（車両識別番号）
        valueRegistry.setValue(vin1, 1); // VIN 123456789 に事故を記録（1回目）

        vm.warp(block.timestamp + 60); // タイムスタンプを1分進める
        valueRegistry.setValue(vin1, 2); // VIN 123456789 に事故を記録（2回目）

        vm.warp(block.timestamp + 120); // さらに2分進める
        valueRegistry.setValue(vin1, 3); // VIN 123456789 に事故を記録（3回目）

        // トランザクションを終了
        vm.stopBroadcast();

        // 5. getAccidentRecords で事故記録（値 + タイムスタンプ）を取得
        ValueRegistry.AccidentRecord[] memory records = valueRegistry.getAccidentRecords(vin1); // 事故履歴を取得
        console.log("Accident records with timestamps for VIN 123456789:");
        for (uint256 i = 0; i < records.length; i++) {
            console.log("Value:", records[i].value); // 各事故記録の値（データ）
            console.log("Timestamp:", records[i].timestamp); // 各事故記録のタイムスタンプ
        }

        // 6. getAccidentCount で事故回数を取得してログに出力
       // 事故回数を取得してログに出力
        try valueRegistry.getAccidentCount(vin1) returns (uint256 accidentCount) {
            console.log("Accident count for VIN 123456789:", accidentCount);
        } catch {
            console.log("Error: Could not retrieve accident count.");
        }


        // スクリプト実行例:
        // forge script script/ValueRegistryScript_Registration.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
    }
}
