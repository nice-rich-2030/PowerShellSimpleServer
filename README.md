# PowerShellSimpleServer

PowerShellで実装された、追加ソフトウェアのインストールが不要なローカル開発用の軽量HTTPサーバーです。

## 背景

HTML、JavaScript、CSSを開発する際には、コードを適切にテストするためのシンプルなWebサーバーが必要になることがよくあります。IISのセットアップやコマンドを手動で実行する従来のアプローチは煩雑です：

```
# 従来のアプローチ
# ステップ1: コマンドプロンプトを開く
# ステップ2: PythonのHTTPサーバーを実行
python -m http.server 8000
# ステップ3: ブラウザを開いてhttp://localhost:8000/your-file.htmlにアクセス
```

PowerShellSimpleServerは、Windowsの組み込み機能で動作する単一ファイルのソリューションを提供することで、このプロセスを効率化します。

## 特徴

- **依存関係なし**: Windowsの組み込みコンポーネントのみを使用
- **シンプルなセットアップ**: 最小限の設定で単一のPowerShellスクリプト
- **ディレクトリ閲覧**: より簡単なナビゲーションのための自動ディレクトリリスト
- **複数のファイルタイプ**: HTML、CSS、JavaScript、画像などをサポート
- **インデックスファイル検出**: ディレクトリにアクセスする際に自動的にindex.html/default.htmlを提供
- **URLデコード**: URLの特殊文字を適切に処理
- **軽量**: システムへの影響が最小限の小さなフットプリント

## 使用方法

### 基本的な使用法

1. PowerShellSimpleServer.ps1スクリプトをコンピュータに保存
2. `$basePath`変数をWebプロジェクトフォルダに向けるように編集
3. PowerShellでスクリプトを実行
4. http://localhost:8000/ でコンテンツにアクセス

```powershell
# 例: D:\WebProjects\MyAppからファイルを提供するように設定
$basePath = "D:\WebProjects\MyApp"  # スクリプト内のこの行を編集
```

### サーバーの実行

```powershell
# 方法1: スクリプトを右クリックして「PowerShellで実行」を選択

# 方法2: PowerShellターミナルから
.\PowerShellSimpleServer.ps1

# 方法3: 最小化して実行するショートカットを作成
# ターゲット: powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\PowerShellSimpleServer.ps1"
# 「実行時の大きさ」を「最小化」に設定
```

### コンテンツへのアクセス

サーバーが実行されると、以下のことができます：

- ブラウザを開いてhttp://localhost:8000/にアクセス
- http://localhost:8000/index.htmlなどの特定のファイルにアクセス
- http://localhost:8000/css/やhttp://localhost:8000/js/などのサブディレクトリを閲覧

### サーバーの停止

PowerShellウィンドウで`Ctrl+C`を押してサーバーを停止します。

## カスタマイズ

### ポートの変更

異なるポート（例：8000の代わりに8080）を使用するには、この行を変更します：

```powershell
$listener.Prefixes.Add("http://localhost:8080/")
```

### 異なるルートフォルダからの提供

`$basePath`変数を変更します：

```powershell
$basePath = "C:\Your\Project\Path"
```

## 制限事項

- **ローカル開発のみ**: このサーバーは本番環境ではなく、開発とテスト目的のみを意図しています
- **シングルスレッド**: 一度に1つのリクエストを処理
- **基本的なセキュリティ**: 認証やHTTPSサポートなし
- **Windowsのみ**: PowerShellを使用するWindows環境用に設計

## トラブルシューティング

### ポートが既に使用中

ポートが使用中であるというエラーが表示される場合：

```powershell
# ポート8000を使用しているものを見つける
netstat -ano | findstr :8000

# スクリプト内のポートを未使用のポートに変更
$listener.Prefixes.Add("http://localhost:8080/")
```

### 実行ポリシーの制限

実行ポリシーの制限に遭遇した場合：

```powershell
# 管理者権限のPowerShellプロンプトでこのコマンドを実行
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ファイルが見つからないエラー

ファイルパスが正しいこと、およびPowerShellプロセスが提供しようとしているファイルに対する読み取り権限を持っていることを確認してください。

## ライセンス

Copyright (c) 2025 Daily Growth  
https://yourworklifedesign.blogspot.com/  
All rights reserved.

---

プログラミングを楽しんでください！ 🚀