# Frontend Architecture

## 1. Architecture Principles

Frontendは、Business Modelが表現する業務概念に基づく表示・操作を担う。Backendのモデル全体の整合性保証とは区別し、Frontendでは画面・操作に必要な入力検証と状態管理を行う。

- **責務による分離**：アプリケーション・Feature・画面の制御と、ARIADNE共通UIの表示構造を分ける。
- **正本の明確化**：現在の入力値はField、現在画面情報はContextなど、情報ごとに状態の所有者を定める。同じ状態を複数箇所で独立して保持しない。
- **業務モデルと接続形式の分離**：Frontend Domain Modelを用い、画面・入力処理がWails生成モデルへ直接依存することを避ける。
- **責務に基づく共通化**：共通化そのものを目的としない。共通UIの内部で完結する振る舞いは共通UI自身が管理してよい。

## 2. Component Structure

### Application / Shell

| 構成要素 | 責務 |
|---|---|
| `App` | アプリケーションの起点 |
| `Shell` | Feature選択、Feature間の離脱調整、通知状態などのアプリケーション全体の制御 |
| `AriadneShell` | アプリケーション共通の表示構造 |

### Management / Page / Entry・ListTable・View / Field

Feature内の構造階層は、次のとおりとする。

```text
Management
└── Page
    └── Entry / ListTable / View
        └── Field
```

Entry・ListTable・Viewは同じ階層に位置し、画面の用途に応じて用いる。各階層の具体的な部品は、対応するARIADNE共通構造部品を利用する。

| Feature側の構成要素 | Feature側の責務 | 対応する共通構造部品とその責務 |
|---|---|---|
| `Management` | Feature内の画面選択、Context、離脱確認、Backend書込み実行と実行後の画面更新 | `AriadneManagement`：Side NavigationとPage領域の共通表示構造 |
| `Page` | 画面固有の操作・状態、登録・更新要求の準備 | `AriadnePage`：タイトル、操作領域、コンテンツ領域などの共通ページ枠 |
| `Entry` | 入力項目の構成、入力モデル・Validationとの連携 | `AriadneForm`：共通Form UI、Submit確認UIとその内部の表示制御 |
| `ListTable` / `View` | 一覧・参照に関するFeature固有の情報と操作判断 | `AriadneListTable` / `AriadneView`：共通表示構造とイベント通知 |
| `Field` | 入力値、単項目Validity、入力・検証に関する具体的な振る舞い | `AriadneField`：共通表示構造とエラー表示。Validityは保持しない |

Pageは描画専用ではない。登録・更新ではPageが入力モデルから要求を準備し、ManagementがBackendへの書込みと成功後の画面更新を制御する。

### ARIADNE共通構造部品と共通利用部品

ARIADNE共通部品は、**Featureの構造階層に対応する共通構造部品**と、**階層に依存せず利用する共通利用部品**に分けて整理する。

- **共通構造部品**：`AriadneShell`、`AriadneManagement`、`AriadnePage`、`AriadneForm`、`AriadneListTable`、`AriadneView`、`AriadneField`など。各階層の具体的な部品と組み合わせて、共通の表示構造を提供する。`AriadneSideNavigation`もManagementの表示構造に用いる。
- **共通利用部品**：Modal、Toast、Toggle、Navigation、Buttonなど。Featureの構造階層そのものを表すものではなく、必要な場所から利用する。

Fieldには`TextField`などの汎用Fieldと、`TaskStatusField`などのFeature固有Fieldがある。**いずれも`AriadneField`と組み合わせて利用する**点は同じである。`AriadneField`はエラーの「表示」を共通化し、入力値やValidityの状態を保持しない。状態管理と検証は具体的なField側が担う。

共通部品を一律に「制御を持たない部品」とはしない。`AriadneModal`はConfirm／Cancelや二重実行防止などModal内部の制御を担い、`AriadneForm`はSubmit確認UIと内部制御を担う。`AriadneToast`は表示時間を管理して終了を通知し、通知内容と表示状態はShellが管理する。`AriadnePage`はToggle等を配置する領域を提供するが、現在のモードや保存・キャンセルの判断はFeatureが管理する。

共通部品と具体的な部品の境界は、見た目の類似性ではなく責務に基づいて定める。

## 3. Frontend Models & Validation

### Frontend Domain Model

Frontend Domain Modelは、Backendから取得した情報をFrontend側の業務概念として表す。Wails生成モデルとFrontend内部の業務モデルを分離し、Wails生成モデルからの変換はFrontend Domain Model側に閉じ込める。

Frontend Domain ModelはStoreが保持する取得データの変更に追従する。具体的な型、生成方法、リアクティブな連携方法はCoreで設計する。

### 入力モデルとField

入力モデルは個々のFieldを参照し、入力全体のValidityや変更差分をリアクティブに集約・導出する。**現在の入力値の正本は各Field**であり、入力モデルが同じ現在値を別途保持することはしない。

### Single / Correlation Validation

| 対象 | 判定処理 | Validity状態の保持 |
|---|---|---|
| Single Validation | 各Fieldに対応する単項目検証 | Field |
| Correlation Validation | 具体的なValidatorが相関チェックを実行 | 呼び出し元のEntry／RowEntry |

Correlation Validatorは**チェック処理のみ**を担い、Validityの状態を保持しない。通常の入力ではEntry、表形式編集ではRowEntryが相関Validityの状態を保持する。

この分離は、相関チェックが複数存在することを前提に、判定ごとに状態を持つValidatorインスタンスを設けることによるメモリ・性能上の懸念を避けるためである。Validatorの具体的なインスタンス生成方式までは、ここでは固定しない。

汎用Validation基盤は共通的な判定の仕組みを提供し、具体的な業務ルールはFeature固有のValidatorに置く。入力モデルはFieldおよびEntry／RowEntryが保持する結果を参照し、入力全体の成立状態を導出する。

## 4. State Management

### Context

ContextはFeature内の現在画面情報の正本となる。ManagementはContextを用いて画面遷移を制御し、同じ画面選択情報を重複して管理しない。

### Store

StoreはBackendからのデータ取得と取得結果の保持を担う。Prototypeの非同期Factoryによる生成方式を継続し、CoreではStoreをリアクティブ化して取得データの変更をFrontend Domain Modelに反映できるようにする。

ただし、**すべての画面にStoreを必須とはしない**。Backend取得データを前提としない新規作成画面などでは、画面の性質に応じてStoreの要否を判断する。

### 状態の所有者

| 情報 | 正本・状態の所有者 |
|---|---|
| 現在画面情報 | Context |
| Backendから取得したデータ | Store |
| 入力中の現在値 | Field |
| 単項目Validity | Field |
| 相関Validity | Entry／RowEntry |
| 通知内容・表示状態 | Shell |
| Toastの表示時間 | AriadneToast |

Frontend Domain Modelは取得データを業務概念として表現し、入力モデルはField等の状態を集約する。これらの役割を、状態の重複保持と混同しない。

## 5. Data Flow

### Backend取得から初期表示まで

1. Backend呼出しの具体的なWails Binding処理を専用TSに分離する。
2. StoreがBackendから取得したデータを保持する。
3. Frontend Domain ModelがWails生成モデルからFrontend側の業務モデルへの変換を担う。
4. PageやEntryはFrontend側の業務モデルに基づいて表示・操作する。

取得・変換・保持・表示の責務を分ける。具体的な呼出し順序、モデル生成・更新の方式はCore初期設計で確定する。

### 登録・更新

1. Pageが入力モデルを参照し、登録・更新要求を準備する。
2. Managementが要求を受け取り、Backendへの書込みを実行する。
3. Backend呼出しは専用のBinding TSを経由する。
4. Managementが結果に応じて画面更新を制御する。

画面固有の入力内容の組み立てと、Feature内の書込み実行・画面更新を分離する。

## 6. Navigation & Lifecycle

画面遷移では、Prototypeで成立した**`prepare → commit`**を継続する。遷移先データの準備に成功した場合のみ画面切替を確定し、失敗時は現在画面と状態を維持する。

離脱確認にはCallback方式を継続する。各画面が必要に応じて離脱可否を判断し、Shell・Management・Pageがそれぞれの責務に従って、離脱確認、遷移先準備、画面切替を連携させる。

Feature離脱時の状態破棄や再選択時の初期化など、個別の画面・Featureの振る舞いは、該当するFeature設計と整合させて具体化する。

## 7. Design Boundaries & Evolution

本書はFrontendの共通構造と責務分担を記録する。具体的なディレクトリ構成、クラス、公開関数、状態連携の実装方法は、必要なCore設計の段階で確定する。

Excelライクな編集、コピー＆ペースト、ListTable拡張、Page内タブ、Side Navigation拡張などは、Feature固有の設計・検証を進め、その結果に応じて**本書にも必要なアーキテクチャ上の決定事項を追記する**。初版に記載がないことは、将来の追記対象から除外する意味ではない。

モデル間の依存関係や変更整合性など、Frontendだけでは成立しない条件については、Backend・Model側の設計との責務境界を維持する。

## Sources

- [Prototype Phase 6 — Review 05: Architecture](https://github.com/teru-0529/project-ariadne-prototype/issues/50)（A02）
- [Prototype Phase 6 — Review 07: Features](https://github.com/teru-0529/project-ariadne-prototype/issues/52)（F05、F02。Coreへの引継ぎとして参照）
