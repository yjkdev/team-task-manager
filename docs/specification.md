## 設計書 - Team Task Manager

### 0. 概要
* 本ツールは、複数のユーザーが所属するワークスペース単位でタスクを共有・管理し、進捗を可視化することを目的としています。
* 本プロジェクトでは、VueテンプレートにPugを導入し、各画面の記述に利用しています。
* このバッチ処理は、cron + rake + Procfile.dev + foreman を活用し、開発サーバー起動と同時に定期集計が行われるよう設計しています。

---

### 1. 画面仕様書（画面構成、入力項目、エラー処理など）

#### ● ログイン画面

* **入力項目**：メールアドレス、パスワード
* **ボタン**：ログイン、会員登録ページへのリンク
* **エラー処理**：

  * 未入力時：バリデーションエラー表示
  * 認証失敗："ログイン情報が正しくありません"

#### ● 会員登録画面

* **入力項目**：名前、メールアドレス、パスワード、パスワード確認
* **ボタン**：登録
* **エラー処理**：

  * パスワード不一致："パスワードが一致しません"
  * その他登録エラー：APIからのエラーメッセージ表示

#### ● ワークスペース画面

* **表示項目**：

  * ログインユーザー名・メール
  * ワークスペース一覧、作成フォーム
  * タスク一覧（選択されたワークスペース）
* **入力項目**：

  * ワークスペース名
  * タスクタイトル、説明、カテゴリ、状態（done/todo）、担当者
  * フィルター（カテゴリ、状態）
* **ボタン**：

  * ワークスペース作成、タスク作成/修正、削除、状態切替、ログアウト、リポートへ遷移
* **エラー処理**：バリデーションエラー、API失敗時のメッセージ表示

#### ● リポート画面

* **表示項目**：各ユーザーのタスク進捗（日時・完了数/総数・進捗率）
* **ボタン**：ワークスペースに戻る

---

### 2. モデル設計書（テーブル・カラム・リレーション構成、ER図）

#### ● users

* id: integer (PK)
* name: string
* email: string
* password\_digest: string

#### ● workspaces

* id: integer (PK)
* name: string

#### ● user\_workspaces (中間テーブル)

* id: integer (PK)
* user\_id: integer (FK)
* workspace\_id: integer (FK)

#### ● tasks

* id: integer (PK)
* title: string
* description: string
* status: string ('todo' or 'done')
* category: string
* workspace\_id: integer (FK)
* assigned\_user\_id: integer (FK)

#### ● task\_progress\_reports

* id: integer (PK)
* user\_id: integer (FK)
* total\_tasks: integer
* done\_tasks: integer
* progress\_rate: float
* collected\_at: datetime

#### ● リレーション

* User has_many :user_workspaces, has_many :workspaces, through: :user_workspaces  
* Workspace has_many :user_workspaces, has_many :users, through: :user_workspaces
* Task belongs\_to \:workspace, belongs\_to \:assigned\_user (User)

#### ● ER図 URL
https://www.erdcloud.com/d/E78ge2i7xqvqm7pcy

---

### 3. 機能設計書（APIや画面単位の処理フロー・バリデーション）
#### ● API TEST URL
https://github.com/yjkdev/team-task-manager/issues/9

#### ● 認証機能

* POST /signup: ユーザー登録（name, email, password）
* POST /login: JWTトークン発行
* GET /me: ログインユーザー情報取得（ヘッダーのJWT検証）

#### ● ワークスペース機能

* GET /workspaces: ログインユーザー所属のワークスペース一覧
* POST /workspaces: 新規ワークスペース作成（作成者をuser\_workspaceに登録）

#### ● タスク管理機能

* GET /workspaces/\:id/tasks: 選択ワークスペースのタスク一覧（status, category, assigned\_user\_idでフィルター）
* POST /workspaces/\:id/tasks: タスク作成（title, description, category, assigned\_user\_id）
* PUT /workspaces/\:id/tasks/\:id: タスク編集
* DELETE /workspaces/\:id/tasks/\:id: タスク削除
* PATCH /workspaces/\:id/tasks/\:id/toggle\_status: 状態切替(todo/done)

#### ● タスク作成フロー
* ユーザー入力（タイトル・説明）→
* APIリクエスト（POST /workspaces/:id/tasks）→
* TasksController#create → TaskService#create_task → Task.* create! → レスポンス返却 → 画面表示更新

#### ● バッチ処理（Rake）

* `rake task_progress:report`

  * 各ユーザーのタスクを集計し、進捗率レポートをtask\_progress\_reportsに保存

#### ● レポート表示

* GET /admin/task\_progress\_reports: 直近10件の進捗レポート一覧取得

---

### 4. 使用技術・ライブラリ一覧

#### ● バックエンド

* Ruby on Rails (APIモード)
* SQLite3
* JWT（認証）
* Rakeタスク（定期処理）

#### ● フロントエンド

* Vue.js 3
* Vite
* Axios（API通信）
* Pinia（状態管理）
* Vue Router

#### ● その他

* GitHub（バージョン管理）
* Pug（使用）
* Taskモデルのバリデーション（title, workspace_id, assigned_user_idの有無）をspec/models/task_spec.rbにて検証済み。