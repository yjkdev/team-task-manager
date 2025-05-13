# Team Task Manager(Ruby on Rails + Vue.js)
## 📢 プロジェクト概要
Vue.js + Ruby on Railsを活用したSaaS型チーム勤務共有ツールです。
ユーザーはチーム単位のワークスペースを作成し、タスク(Task)を登録・参照・編集・削除でき、Rake Taskにより定期的な完了率の集計も行います。

## 🔧 使った技術

### Backend
- Ruby on Rails 7 (API モード)
- JWT 認証 (devise なしで純粋に実現)
- Rake Task (業務完了率集計)
- SQLite3

### Frontend
- Vue 3 + Vite
- Pinia (ステータス管理)
- Vue Router
- Axios
- Composition API

## 📌 機能概要

### ✅ 認証 (JWT)
- サインアップ / ログイン / ログアウト
- JWT 発行と Pinia での情報管理

### 🧩 ワークスペース
- 新規作成
- ユーザーごとの所属ワークスペース参照

### 📝 タスク管理
- タイトル、説明、ステータス、カテゴリー、担当者
- 編集 / 削除
- 状態トグル
- 状態・カテゴリー別フィルター

### 📊 Rake Task - 業務完了率集計
- rake task_progress:report により勤務経過を定期集計
- /admin/task_progress_reports で最新の集計結果を参照

## 🧪 テスト

- RSpec 使用
- `spec/models/task_spec.rb`に有効性テスト付き

## 🔧 セットアップ方法

### 1️⃣ バックエンド（Rails）の起動
```bash
cd backend
bundle install
rails db:create db:migrate db:seed
foreman start -f Procfile.dev
```
### 2️⃣ フロントエンド（Vue.js）の起動
```bash
cd frontend
npm install
npm run dev
```

## 🔥工夫したポイント

### 1. バッチ処理を自動化し、定期的な実行環境を整備した点
- Rakeタスクを使って、各ユーザーのタスク進捗率（完了率）を集計し、task_progress_reportsテーブルに保存する処理を実装しました。
- wheneverとcronを組み合わせて、3分ごとに定期実行されるバッチ処理としてスケジュールを構築しました。
- Routerのナビゲーションガード設定

### 2. JWT(JSON Web Token)認証方式の導入
- Rails API と Vue.js の通信をセキュアにするため JWTを利用
- ログイン時に登録情報を含めたトークンを発行
- Procfile.devを使ってRailsサーバー起動と同時にcronスケジュールの設定も一括で行えるようにし、手動操作なしで自動起動可能な開発環境を整備しました。

## ✅ 単体テスト実行方法

### 1. モデルテスト (Model Test)

```bash
rspec spec/models
```

### 2. APIテスト (Request Test)

```bash
rspec spec/requests
```

### 3. 全テストの一括実行

```bash
rspec
```

## 🖼️ 画面構成

| ページ | 説明 |
|--------|------|
| `/login` | ログイン |
| `/signup` | サインアップ |
| `/workspace` | ワークスペース作成 / リスト / 選択時のタスクリスト出力 |
| `/report` | ユーザー別業務完了率リスト |
