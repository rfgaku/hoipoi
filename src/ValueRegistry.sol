// Solidity example with owner restriction
pragma solidity ^0.8.0;

contract ValueRegistry {
    // idをキーとしてvalueをマッピングする
    mapping(uint256 => uint256) private values;
    address private owner;

    // コンストラクタでデプロイ時のアカウントを owner に設定
    constructor() {
        owner = msg.sender;
    }

    // 値を設定する関数（ownerのみ実行可能）
    function setValue(uint256 id, uint256 value) public {
        require(msg.sender == owner, "Only the contract owner can set the value.");
        values[id] = value;
    }

    // 値を取得する関数（誰でも実行可能）
    function getValue(uint256 id) public view returns (uint256) {
        return values[id];
    }
}