# Backend Architecture

## 1. Architecture Principles

Backendは**Business Modelを中心**に設計する。業務上のルール・制約・整合性はBusiness Modelが最終的に保証し、Application ServiceやPersistence Adapterへ判断を移さない。

| 構成要素 | 責務 |
|---|---|
| Business Model | 業務概念、制約、確定済みモデルの整合性保証 |
| Application Service | ユースケースの組み立て、モデル操作、Public Modelへの写像 |
| Public Model | 利用目的に応じたBusiness Modelの表現 |
| Persistence Model | YAMLの永続化形式を表現するデータ構造 |
| Persistence Port | Serviceが必要とする永続化操作の抽象 |
| Persistence Adapter | Portの実装、Persistence ModelとBusiness Modelの相互変換 |

「Go Service First」は採用しない。Serviceはユースケースの実行を調整するが、モデル成立条件の最終判断はしない。

Elements・DB・APIを独立した業務領域として扱う。単一アプリケーション内で責務を分離し、全領域を束ねる巨大なBusiness Modelは設けない。

## 2. Model Separation

同じ業務定義を異なる視点から表す**Business Model／Public Model／Persistence Model**を分離する。これらの構造が一致している必要はない。

- **Business Model**：可能な限り構造とロジックで業務上の意味を表現する。変更可否のような導出情報を無条件にフラグで保持しない。
- **Public Model**：Business Modelを利用目的に応じて写像した結果。画面が必要とする変更可否情報なども含められる。生成はApplication Serviceの責務とする。
- **Persistence Model**：保存形式を表す。Persistence Adapterの内部に閉じ、Business Model・Application Serviceからは参照しない。

業務判断をPublic Modelの生成処理やAdapterに移さない。Application ServiceはBusiness Modelの判断結果をPublic Modelへ反映する。

Mutable Elementsの参照・利用状況はElements単独の定義から導出できないため、DB・API由来の参照情報を構築時に与える。参照情報の抽出と、それに基づく業務判断の責務を区別する。

## 3. Business Model

### Elements・DB・API

Elements、DB、APIはそれぞれ独立したBusiness Modelを持ち、配下の定義が0件でもモデルの外枠が存在する。

DB Model・API Modelは**Immutable Elements Model**を参照する。ElementsのMutable／Immutableは生成時に確定し、生成後に切り替えない。ここでのImmutableは深い不変化を意味せず、変更操作を許さないことを意味する。

Mutable Elementsを構築する場合、DB・APIでの参照状況を取得時の定義に基づき与える。別々のユースケースで取得したモデル同士の常時同期は前提としない。利用中のElementの変更には制約が生じるが、具体的な属性別の変更可否は各モデルの成立条件として設計する。

### Elements Builder

Elements BuilderはElement定義と参照情報を受け取り、DB由来・API由来の参照を区別して`AddReference()`で追加する。 `Build()`で参照状況と整合性を確定し、完成したElements Modelには外部から参照状況を変更する操作を公開しない。

参照情報の抽出・供給はAdapterが担い、参照に基づく利用状況の業務判断はBuilder側が担う。Immutable ElementsにMutable編集用の利用状況を必須とはしない。

### DB・Table・FK

DB Modelが**DB全体の整合性の最終責任**を持つ。TableとFKはDBの直下の兄弟関係とし、TableはColumn・Indexなどを所有する。Table内部の整合性と、FKを含むDB全体の整合性を区別する。

FKが成立している間は参照関係を壊すキー構成の変更を認めない。変更が必要な場合は先にFKを解除する。TableとFKの編集は独立した操作とし、双方を一度に編集するトランザクションは想定しない。

### TableEditと確定操作

正式なTableはモデルの操作を通じて変更し、その内部状態を外部へ無制限に公開しない。一方、`TableEdit`は編集中の構造であり、Column・Indexを含む一時的な不整合を許容する。

`DB.PutTable(TableEdit)`を正式な確定操作とし、Tableの内部整合性を確認した後、変更後のTableを仮に組み込んだ**DB全体のTable・FK**の整合性を確認する。変更対象が他のTableから参照されている場合も検証対象に含む。

すべて成立した場合のみ新規Tableの登録または既存Tableの変更を確定する。既存Tableについてはインスタンスを維持し、検証済みの状態を反映する方針とする。検証が失敗した場合は既存の確定済み状態を変更せず、BackendのUnexpected Errorとして拒否する。

Tableから親DBへの逆参照は、`PutTable()`のためだけには不要である。ただし、正式なTableがDB全体の情報を利用する操作の有無により必要性が変わるため、**採否は未確定**とし、具体的なモデル操作の設計で判断する。

### 成立条件

YAMLからの復元と画面操作に基づく更新は異なる経路でもよいが、正式なBusiness Modelへ適用する**成立条件は同じ**とする。不完全なモデルを確定済みモデルとして返さない。

Elements Builderや`DB.PutTable()`などの確定方式は領域の構造に応じて異なってよく、無理に一つのAPIへ統一しない。

## 4. Application Service

初期構成として次の4つを設ける。

| Service | 責務 |
|---|---|
| Elements Service | Elementsの取得・変更ユースケース、Mutable Elementsの利用、Public Modelへの写像 |
| DB Service | DB・Table・FK等の取得・変更ユースケース、Public Modelへの写像 |
| API Service | API定義の取得・変更ユースケース、Public Modelへの写像 |
| Configure Service | アプリケーション設定の取得・変更・保存 |

Elements／DB／API Serviceは各領域のPersistence Portを利用し、他領域のServiceへの依存を前提としない。変更要求を解釈し編集用Business Modelへ反映するが、業務上の整合性判断はBusiness Modelが担う。

Public ModelはServiceが利用目的に応じて生成する。例えばTableの参照・編集画面向けには、Tableの定義とDB全体から導いた変更可否情報を組み合わせる。画面へDB Model全体をそのまま渡す必要はない。

### Configure Service

Configure Serviceはユーザー領域の`configure.yaml`に保存する**アプリケーション設定**を扱う。設定の取得・変更・保存を担い、Configure Portを通じて永続化する。

`configure.yaml`の保存先はWindowsの`%LOCALAPPDATA%`配下を想定する。Workspace内の`ariadne.yaml`にあるElements／DB／APIの業務定義そのものの永続化は担当しない。

Workspaceの選択・確認、業務定義の復元、および他Serviceとの具体的な連携方法は、該当するユースケースの設計において責務を確定する。ここで未合意の呼び出し関係を固定しない。

## 5. Persistence Port / Adapter

初期構成では4領域のPort／Adapterを設ける。

| Port / Adapter | 永続化の対象 |
|---|---|
| Elements Port / Adapter | Elementsの業務定義 |
| DB Port / Adapter | DBの業務定義 |
| API Port / Adapter | APIの業務定義 |
| Configure Port / Adapter | アプリケーション設定 |

### 業務定義の永続化

Elements／DB／APIの唯一の正本は、Workspace内の単一ファイル`ariadne.yaml`とする。各領域のAdapterはPersistence ModelとBusiness Modelの相互変換を担い、YAML全体の物理的な読み書きには共通処理を利用する。

Port／Adapterの分割単位と物理ファイルの保存単位は一致する必要がない。Business ModelとApplication ServiceはPersistence Modelを知らない。

主な取得パターンは以下とする。

| 領域 | 取得するモデル |
|---|---|
| Elements | Mutable Elements |
| DB | Immutable Elements ＋ DB Model |
| API | Immutable Elements ＋ API Model |

DB／APIではImmutable Elementsを先に成立させてから領域モデルを復元する。Mutable ElementsではDB／API由来の参照情報をBuilderへ供給する。復元時にモデルの成立条件を満たさなければ、取得失敗として扱う。

更新もElements／DB／APIの3領域を単位とし、Table・FK等の個別操作ごとにPersistence Portを増やさない。DB／APIの更新時にImmutable Elementsを更新対象とはしない。

対象領域のみPersistence Modelへ反映し、**対象外の定義を維持したうえで**YAML全体を保存する。保存途中の失敗で既存ファイルを壊さないよう、一時ファイルを用いた原子的な置換を継続する。更新処理はアプリ内で直列化する。複数プロセス間の複雑な排他制御は初期対象外とする。

更新日時は定義個別ではなくYAML全体で管理する方向とし、具体的な更新方式はPersistence設計で定める。空の初期定義を作成する場合も、Elements・DB・APIの成立条件を守る。

### アプリケーション設定の永続化

Configure Portは設定の永続化を抽象化し、Configure Adapterがユーザー領域の`configure.yaml`の読み書きを実装する。

`configure.yaml`と`ariadne.yaml`は別のファイルであり、**読み書きの責務を分離**する。Configure AdapterはElements／DB／APIの業務定義を保存しない。

## 6. Data Flow

### 業務定義の取得

1. Application Serviceが対象領域のPersistence Portを利用する。
2. 対応するAdapterが共通YAML読み込み処理を通じてPersistence Modelを取得する。
3. AdapterがBusiness Modelの生成・追加・確定操作を用いて復元する。必要なImmutable Elementsや参照情報を組み立てる。
4. 正式に成立したBusiness ModelをPort経由でServiceへ返す。
5. Serviceが利用目的に応じてPublic Modelへ写像する。

### 業務定義の更新

1. Application Serviceが更新要求を解釈し、編集用Business Modelに操作を適用する。
2. Business Modelが正式な変更の成立条件を検証・確定する。
3. Serviceが対象領域のBusiness ModelをPersistence Portへ渡す。
4. Adapterが対象領域をPersistence Modelへ反映し、共通YAML処理を通じて単一ファイル全体を原子的に保存する。

確定済みのBusiness Modelと保存済みファイルは別の状態であり、保存失敗を成功として扱わない。

### アプリケーション設定の取得・更新

1. Configure ServiceがConfigure Portを呼び出す。
2. Configure Adapterがユーザー領域の`configure.yaml`を読み書きする。
3. Workspace内の`ariadne.yaml`の業務定義読み書きはElements／DB／API側のPort／Adapterが担う。

## 7. Design Boundaries

本書はBackendの共通原則、モデル間の分離と責務、Service／Port／Adapterの構成を記録する。具体的な型、公開関数、ファイル配置、モデル属性は、各領域の設計で定める。

- **Business Model詳細**：Elements・Enum・Table・Column・Index・FK・APIの具体的な構造・成立条件・参照関係はModel設計で具体化する。TableからDBへの逆参照は未確定とする。
- **Application Boundary**：Wails Boundary、公開メソッド、Frontendへの型の受け渡し・エラー伝達は別文書で扱う。
- **Persistence詳細**：単一YAMLのSchema、Schema Version、更新日時、原子的保存の詳細、Workspaceの取り扱いはPersistence設計と整合させる。
- **Configure連携**：Configure Serviceの初期設置および`configure.yaml`の永続化責務は確定済みとする。他Serviceとの連携、Workspaceの確認・切り替え時の具体的な実行順は、関係する設計で定める。
- **横断的関心事**：Error Handling、Logging、機密情報の保管などはCross-cutting Concernsで整理する。通常設定ファイルへ秘密情報を直接保存しない。
- **Feature設計**：変更可否を利用するFrontend操作、Table編集、初期Workspace生成等の具体的な動作はFeatureごとに設計し、Backendの共通原則に関わる決定は必要に応じて本書へ反映する。

## Sources

- [Prototype Phase 6 — Review 05: Architecture](https://github.com/teru-0529/project-ariadne-prototype/issues/50)（A03を中心にA01・A05・A06も参照）
