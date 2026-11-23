# Persistence Architecture

## 1. Architecture Principles

Persistenceは、ARIADNEが扱うデータの永続化を担う。

- 永続化処理はPersistence Portを介して利用し、Application Serviceを具体的な保存方式に依存させない。
- Persistence Adapterが保存データとの変換および読み書きを担当する。
- Business ModelとPersistence Modelを分離し、業務上の整合性と保存形式の責務を区別する。
- 永続化対象をWorkspace領域とユーザー領域に分け、それぞれのデータの役割と保存先を明確にする。
- `ariadne.yaml`をWorkspaceの設計データの正本とする。

## 2. Logical Structure

永続化は、Application Service、Persistence Port、Persistence Adapterを通じて実行する。

| 要素 | 責務 |
|---|---|
| Application Service | 永続化操作の呼び出しと処理の調整 |
| Persistence Port | 永続化に必要な操作の抽象化 |
| Persistence Adapter | Portの実装、保存データの読み書きと変換 |
| Persistence Model | 永続化形式に合わせたデータ表現 |

Application ServiceはPersistence Portに依存し、Persistence Adapterの具体的な実装には依存しない。

Persistence Adapterは、必要に応じてBusiness Modelを参照し、Business ModelとPersistence Modelの間の変換を担う。

### 永続化対象の区分

| 区分 | 対象 | 役割 |
|---|---|---|
| Workspace領域 | `ariadne.yaml` | 設計データの保存 |
| ユーザー領域 | `configure.yaml` | アプリケーションの利用設定の保存 |

ユーザー領域の設定情報については、ConfigureService／ConfigurePortを介して読み書きする。

両領域は保存する情報の性質が異なるため、永続化の責務を区別する。

## 3. Data Flow

### Workspace領域の読込

1. Application ServiceがPersistence Portを介して読込を要求する。
2. Persistence Adapterが対象の`ariadne.yaml`を読み込む。
3. Persistence Adapterが保存データをBackendで扱うデータ表現へ変換する。
4. 読み込んだデータをBusiness Modelとして利用する。

### Workspace領域の保存

1. Application ServiceがPersistence Portを介して保存を要求する。
2. Persistence Adapterが保存対象をPersistence Modelへ変換する。
3. Persistence Adapterが`ariadne.yaml`へ保存する。
4. 保存結果をApplication Serviceへ返す。

保存形式に関する変換はPersistence Adapterの責務とし、業務上の整合性はBusiness Modelの責務とする。

### ユーザー領域の読込・保存

ユーザー領域の設定情報は、ConfigureService／ConfigurePortを介して読み書きする。

設定情報の永続化においても、処理の呼び出しと具体的なファイル操作の責務を分離する。

## 4. Storage & File Management

### Workspace領域

Workspaceの設計データは、単一の`ariadne.yaml`を正本として管理する。

- 既存Workspaceは、`ariadne.yaml`を指定して開く。
- 新規Workspaceは、フォルダを指定して`ariadne.yaml`を作成する。
- Workspaceの保存先は、ユーザーが指定した場所とする。
- Workspaceごとに保存対象と変更検知の状態を管理する。

### ユーザー領域

アプリケーションの利用設定は、ユーザー領域の`configure.yaml`に保存する。

設定情報には、Workspaceの利用に必要な情報や、デフォルトServiceなどの利用設定を含める。

ユーザー領域の設定はWorkspaceの設計データとは独立して管理し、`ariadne.yaml`には含めない。

### 生成物との関係

DDL、OASなどの生成物は、Workspaceの設計データから生成する。

生成物は`ariadne.yaml`とは区別し、正本として扱わない。

生成先はWorkspace直下の`dist/`とし、生成時は既存の生成物を上書きする。

生成処理の成功と、`ariadne.yaml`の保存成功は別の結果として扱う。

## 5. Consistency & Failure Handling

### 外部変更の検知

Workspaceの`ariadne.yaml`については、BackendがWorkspace単位でHashを保持する。

保存時にファイルのHashを再計算し、保持しているHashとの比較によって外部変更を検知する。

外部変更が検知された場合は、保存を拒否する。

### 保存結果とエラー

- 保存の成功・失敗を呼び出し元へ返す。
- 外部変更が検知された場合は、既存ファイルを上書きしない。
- 保存処理と生成処理の結果は区別する。
- Backend内部のエラー変換とログ出力は、Application Boundaryで定義した責務分担に従う。

業務上の整合性はBusiness Modelが保証し、Persistenceは保存対象の読み書きと保存状態の管理を担う。

## 6. Design Boundaries & Evolution

本書は、Workspace領域およびユーザー領域の永続化構造、データ表現、保存方式、整合性に関する共通的な責務を定義する。

具体的なPortのメソッド、Persistence Modelの型、YAMLの詳細構造、ファイル操作の実装方法は、必要な設計の段階で確定する。

Business Modelの業務ルールとApplication Serviceの責務はBackend Architecture、FrontendとBackendの接続契約はApplication Boundaryで扱う。

各Featureの設計・検証を通じて永続化に関する共通的な決定が生じた場合は、本書にも必要なアーキテクチャ上の決定事項を追記する。
