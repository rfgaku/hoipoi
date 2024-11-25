// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol";

// ValueRegistry コントラクトをデプロイするための Foundry 向けスクリプト。デプロイを自動化するためのツール。
contract Deployment is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // 環境変数から秘密鍵を取得
        vm.startBroadcast(deployerPrivateKey);//EOA（Externa Owned Account）としてトランザクションをブロードキャスト（送信）する準備。
        //この段階で秘密鍵が使われて、デプロイ時の署名が付与される

        // ValueRegistry コントラクトをデプロイ。スマートコントラクトとしてブロックチェーン上に配置される
        ValueRegistry vr = new ValueRegistry();

        vm.stopBroadcast(); //トランザクションの終了。ここで秘密鍵の署名や送信プロセスが完了

        // デプロイされたアドレスをログ出力。これによって、デプロイ後のアドレスを把握可能。
        bytes memory encodedData = abi.encodePacked(
            "Deployed address: ",
            vm.toString(address(vr))
        );
        console.log(string(encodedData));
    }
}
//forge script script/Deployment.s.sol --rpc-url http://127.0.0.1:8545 --broadcast
//デプロイするときのコマンド