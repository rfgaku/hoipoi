// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ValueRegistry.sol";

contract Deployment is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // 環境変数から秘密鍵を取得
        vm.startBroadcast(deployerPrivateKey);

        // ValueRegistry コントラクトをデプロイ
        ValueRegistry vr = new ValueRegistry();

        vm.stopBroadcast();

        // デプロイされたアドレスをログ出力
        bytes memory encodedData = abi.encodePacked(
            "Deployed address: ",
            vm.toString(address(vr))
        );
        console.log(string(encodedData));
    }
}
