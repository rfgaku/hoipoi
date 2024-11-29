// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValueRegistry {
    // 事故記録（値とタイムスタンプ）を保持するための構造体。
    // 「事故の記録」を1つのデータセットとして管理するための型。
    struct AccidentRecord {
        uint256 value;      // 事故データの記録
        uint256 timestamp;  // 記録された日時（UNIXタイムスタンプ）
    }

    // VIN No.（uint256） をキーとして事故記録（値 + タイムスタンプ）を管理。
    // 各VINに紐づく複数の事故記録を保持するため、AccidentRecordの配列構造。
    mapping(uint256 => AccidentRecord[]) private values;

    // コントラクトのオーナーアドレス。privateにより、外部からのアクセスを制限。
    address private owner;

    // コンストラクタ関数
    // デプロイ時に実行され、コントラクトのオーナーを設定する。
    constructor() {
        owner = msg.sender; // 「msg.sender」は現在コントラクトを呼び出しているアカウントのアドレス
    }

    // 新しい事故を記録する関数（コントラクトのオーナーのみ実行可能）。
    // VIN（車両識別番号）に紐づけて事故記録を保存する。
    function setValue(uint256 vin, uint256 value) public {
    //値を設定する関数（owner のみ実行可能）。msg.sender == owner かどうかを確認、エラーしたらメッセージとtx巻き戻し。
        require(msg.sender == owner, "Only the contract owner can set the value.");

        // 指定されたVINに対して、新しい事故記録を追加。
        values[vin].push(AccidentRecord({
            value: value,
            timestamp: block.timestamp // 現在のブロックのタイムスタンプを記録
        }));
    }

    // 指定されたVINに紐づく事故記録（値とタイムスタンプ）を取得する関数。
    function getValue(uint256 vin) public view returns (uint256, uint256) {
        // VINに紐づく事故記録が存在するか確認。存在しない場合はrevert。
        require(values[vin].length > 0, "No accident data found for this VIN.");

        // 最新の事故記録を取得。
        AccidentRecord memory latestRecord = values[vin][values[vin].length - 1];
        return (latestRecord.value, latestRecord.timestamp);
    }

    // 事故回数を取得する関数。
    // 指定されたVINに紐づく事故記録の件数を返す。
    function getAccidentRecords(uint256 vin) public view returns (AccidentRecord[] memory) {
    return values[vin]; // 配列のデータをそのまま返す
    }

    function getAccidentCount(uint256 vin) public view returns (uint256) {
        return values[vin].length;
    }

}