# Hoipoi

車両の事故履歴を記録・確認するためのDAppです。

## セットアップと実行手順

### 0. 作業ディレクトリの確認
まず、正しいディレクトリにいることを確認してください：

```bash
pwd
```

出力：
```
.../hoipoi
```

### 1. 環境構築

#### 前提条件のチェック
以下のコマンドで必要なツールがインストールされているか確認してください：

```bash
# Foundryのインストール確認
forge --version
cast --version
anvil --version

# Node.jsのインストール確認
node --version  # v16.0.0以上であることを確認
npm --version
```

期待される出力例：
```bash
forge 0.2.0 (...)
cast 0.2.0 (...)
anvil 0.2.0 (...)
v16.20.0
8.19.4
```

インストールされていない場合は、以下のコマンドでインストールしてください：

```bash
# Foundryのインストール
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Node.jsのインストール（推奨バージョン）
# macOSの場合
brew install node

# Linuxの場合
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### .envファイルの作成
以下のコマンドを実行して`.env`ファイルを作成します：

```bash
echo "PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80" > .env
```

> 注意: この秘密鍵はAnvilのデフォルトアカウント用です。本番環境では絶対に使用しないでください。

#### 前提条件
- Foundryがインストールされていること
- Node.jsがインストールされていること

### 2. スマートコントラクトのデプロイ

#### ローカルネットワークの起動
```bash
anvil
```

#### コントラクトのデプロイ
別のターミナルウィンドウで実行：
```bash
forge script script/Deployment.s.sol --rpc-url http://localhost:8545 --broadcast
```

デプロイ後、出力されたコントラクトアドレスをメモしてください。

### 3. テストデータの登録

#### コントラクトアドレスの更新
`ValueRegistryScript_Registration.sol`の中のアドレスを更新：
```solidity
address valueRegistryAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3; // デプロイで取得したアドレス
```

#### 登録スクリプトの実行
```bash
forge script script/ValueRegistryScript_Registration.sol --rpc-url http://localhost:8545 --broadcast
```

### 4. フロントエンドの起動

#### パッケージのインストールと起動
```bash
cd hoipoi-web
npm install
npm run dev
```

## 使用方法

### MetaMaskの設定
1. ネットワークをLocalhost 8545に設定
2. アプリケーションとの接続を確認

### VIN番号の確認
1. http://localhost:3000 にアクセス
2. VIN番号「123456789」を入力
3. 「確認」ボタンをクリック
4. 事故履歴と回数を確認
