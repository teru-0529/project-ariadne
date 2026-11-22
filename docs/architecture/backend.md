# Backend Architecture

## 1. Architecture Principles

Backendは、業務ルール、処理の調整、永続化の責務を分離する。

- 業務ルールはBusiness Modelに集約する。
- Application Serviceは処理を調整し、業務ルールを保持しない。
- 永続化はPortを介して利用し、実装技術への直接依存を避ける。
- 各要素の依存方向を明確にし、循環依存を認めない。

## 2. Logical Structure

Backendは以下の論理要素で構成する。

| 要素 | 責務 |
|---|---|
| Application Service | ユースケースの実行、Business Modelの操作、永続化の調整 |
| Business Model | 業務上の状態、ルール、整合性の管理 |
| Persistence Port | 永続化に必要な操作の抽象化 |
| Persistence Adapter | Persistence Portの実装、保存データとの変換 |

これらは論理的な責務の区分であり、パッケージ構成やファイル構成を直接規定するものではない。

## 3. Dependency Rules

コード上の依存関係は次の原則に従う。

- Application ServiceはBusiness ModelおよびPersistence Portに依存する。
- Persistence AdapterはPersistence Portを実装し、必要に応じてBusiness Modelを参照する。
- Business ModelはApplication ServiceやPersistence Adapterに依存しない。
- Application ServiceはPersistence Adapterの具体的な実装に依存しない。

依存関係と実行時の処理順序は区別する。

## 4. Data Representation

Backendでは、責務に応じてデータ表現を分離する。

| データ表現 | 位置づけ |
|---|---|
| Business Model | 業務ルールと整合性を持つ内部表現 |
| Public Model | Backendの境界を越えて公開するデータ表現 |
| Persistence Model | 永続化形式に対応するデータ表現 |

Business Modelを公開形式や保存形式と同一視しない。

データ表現の変換は、それぞれの境界を担当する要素が責任を持つ。具体的な型、変換処理、データ構造は個別設計で定義する。

## 5. Design Boundaries

Backend Architectureは、Backend内部の論理構造と依存原則を定義する。

他のArchitecture文書との責務分担は次のとおり。

| 文書 | 主な対象 |
|---|---|
| Overall / System Architecture | システム全体の構成 |
| Backend Architecture | Backend内部の責務と依存関係 |
| Application Boundary | FrontendとBackendの接続契約 |
| Persistence Architecture | 永続化の構造と実現方式 |
| Cross-cutting Concerns | 複数の構成要素にまたがる共通事項 |

個別の業務モデル、操作、検証ルール、保存データの構造は、この文書では定義しない。
