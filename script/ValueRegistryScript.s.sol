// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol"; // コントラクトのインポート

contract ValueRegistryScript is Script {
    function setUp() public {}

    function run() public {
    // 1. デプロイしたコントラクトのアドレスを設定
    address valueRegistryAddress = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512;

    // 2. コントラクトのインスタンスを作成
    ValueRegistry valueRegistry = ValueRegistry(valueRegistryAddress);

    // 3. トランザクションを開始
    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(deployerPrivateKey);

    // 複数の VIN number を登録
    uint256 vin1 = 123456789;
    uint256 vin2 = 987654321;
    uint256 vin3 = 111222333;
    uint256 vin4 = 111222344;

    valueRegistry.setValue(vin1, 1); // VIN 123456789 に事故あり
    valueRegistry.setValue(vin2, 0); // VIN 987654321 に事故なし
    valueRegistry.setValue(vin3, 1); // VIN 111222333 に事故あり
    valueRegistry.setValue(vin4, 1); // VIN 111222333 に事故あり

    // トランザクションを終了
    vm.stopBroadcast();

    // 登録したデータを取得
    uint256 retrievedValue1 = valueRegistry.getValue(vin1);
    uint256 retrievedValue2 = valueRegistry.getValue(vin2);
    uint256 retrievedValue3 = valueRegistry.getValue(vin3);
    uint256 retrievedValue4 = valueRegistry.getValue(vin4);

    // 結果をログ出力
    console.log("VIN 123456789: Accident Status =", retrievedValue1);
    console.log("VIN 987654321: Accident Status =", retrievedValue2);
    console.log("VIN 111222333: Accident Status =", retrievedValue3);
    console.log("VIN 111222344: Accident Status =", retrievedValue4);

    //forge script script/ValueRegistryScript.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
    //をterminalに入力で実行
}
}