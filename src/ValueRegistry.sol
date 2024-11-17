// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValueRegistry {
    // 事故記録（値とタイムスタンプ）を保持するための構造体
    struct AccidentRecord {
        uint256 value;      // 事故の有無（1:あり、0:なし）
        uint256 timestamp;  // 記録された日時（UNIXタイムスタンプ）
    }

    // VIN No. をキーとして事故記録（値 + タイムスタンプ）の配列を保持
    mapping(uint256 => AccidentRecord[]) private values;

    // コントラクトのオーナーアドレス
    address private owner;

    // コンストラクタでデプロイ時のアカウントを owner に設定
    constructor() {
        owner = msg.sender;
    }

    // 値を設定する関数（owner のみ実行可能）
    function setValue(uint256 id, uint256 value) public {
        require(msg.sender == owner, "Only the contract owner can set the value.");
        values[id].push(AccidentRecord({
            value: value,
            timestamp: block.timestamp
        }));
    }

    // 最新の事故記録を取得する関数
    function getValue(uint256 id) public view returns (uint256) {
        require(values[id].length > 0, "No accident data found for this VIN.");
        return values[id][values[id].length - 1].value;
    }

    // 事故記録の全ての値を配列として取得する関数
    function getAllValues(uint256 id) public view returns (uint256[] memory) {
        uint256[] memory allValues = new uint256[](values[id].length);
        for (uint256 i = 0; i < values[id].length; i++) {
            allValues[i] = values[id][i].value;
        }
        return allValues;
    }

    // 事故記録（値 + タイムスタンプ）を全て取得する関数
    function getAccidentRecords(uint256 id) public view returns (AccidentRecord[] memory) {
        return values[id];
    }
}
