// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValueRegistry {
    // 事故記録（値とタイムスタンプ）を保持するための構造体。「事故の記録」を1つのデータセットとして管理するための型。
    struct AccidentRecord {
        uint256 value;      // 事故の有無（1:あり、0:なし）
        uint256 timestamp;  // 記録された日時（UNIXタイムスタンプ）
    }

    // VIN No.（uint256） をキーとして事故記録（値 + タイムスタンプ）
    mapping(uint256 => AccidentRecord[]) private values; //（rd[]）の配列を保持。1つのvinに複数の事故歴を保持できるように配列構造

    // コントラクトのオーナーアドレス。privateにより、外部からアクセス制限。
    address private owner;

    // コンストラクタ関数で（デプロイする時に一度だけ実行される）でデプロイ（初期化）時のアカウントを owner に設定
    constructor() {
        owner = msg.sender; // 「msg.sender」は現在このコントラクトを呼び出しているアカウントのアドレス=EOA
    }

    // 値を設定する関数（owner のみ実行可能）。msg.sender == owner かどうかを確認、エラーしたらメッセージとtx巻き戻し。
    function setValue(uint256 id, uint256 value) public {
        require(msg.sender == owner, "Only the contract owner can set the value.");
        values[id].push(AccidentRecord({ // idに対するvalueの配列に新しいAccidentRecordを追加
            value: value,
            timestamp: block.timestamp
        }));
    }

    // 最新の事故記録を取得する関数
    function getValue(uint256 id) public view returns (uint256) {
        require(values[id].length > 0, "No accident data found for this VIN.");
        return values[id][values[id].length - 1].value;
    }

    // 事故記録の全ての値を配列として取得する関数。指定した VIN No. (id) に紐づく すべての事故記録の「値」（value）だけ を配列として取得する。
    function getAllValues(uint256 id) public view returns (uint256[] memory) {
        uint256[] memory allValues = new uint256[](values[id].length);
        for (uint256 i = 0; i < values[id].length; i++) {
            allValues[i] = values[id][i].value;
        }
        return allValues;
    }

    // 事故記録（値 + タイムスタンプ）を全て取得する関数。実際の各vinに対しての事故記録を調べる際に使用する。
    // 指定した VIN No. (id) に紐づく 事故記録のすべてのデータ（値 + タイムスタンプ） をそのまま配列で取得する
    function getAccidentRecords(uint256 id) public view returns (AccidentRecord[] memory) {
        return values[id];
    }
}
