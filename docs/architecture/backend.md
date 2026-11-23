# Backend Architecture

## 1. Architecture Principles

Backendは、業務ルール、処理の調整、永続化の責務を分離する。

- 業務ルールはBusiness Modelに集約する。
- Application Serviceは処理を調整し、業務ルールを保持しない。
- 永続化はPortを介して利用し、実装技術への直接依存を避ける。
- 各要素の依存方向を明確にし、循環依存を認めない。

## 2. Logical Structure

Backendは以下の論理要素で構成する。

| 要素                | 責務                                                   |
| ------------------- | ------------------------------------------------------ |
| Application Service | ユースケースの実行、Business Modelの操作、永続化の調整 |
| Business Model      | 業務上の状態、ルール、整合性の管理                     |
| Persistence Port    | 永続化に必要な操作の抽象化                             |
| Persistence Adapter | Persistence Portの実装、保存データとの変換             |

これらは論理的な責務の区分であり、パッケージ構成やファイル構成を直接規定するものではない。

## 3. Dependency Rules

コード上の依存関係は次の原則に従う。

| 要素                | 依存関係                                                                                  |
| ------------------- | ----------------------------------------------------------------------------------------- |
| Application Service | Business ModelとPersistence Portに依存し、Persistence Adapterの具体的な実装には依存しない |
| Business Model      | Application ServiceやPersistence Adapterに依存しない                                      |
| Persistence Adapter | Persistence Portを実装し、必要に応じてBusiness Modelを参照する                            |

## 4. Data Representation

Backendでは、Business Modelを基に、責務に応じたデータ表現を分離する。

| データ表現        | 位置づけ                                                               |
| ----------------- | ---------------------------------------------------------------------- |
| Business Model    | 業務ルールと整合性を持つ内部表現                                       |
| Public Model      | Business Modelの写像として、Backendの境界を越えて公開するデータ表現    |
| Persistence Model | Business Modelの保存に必要な情報を、永続化形式に合わせて表すデータ表現 |

Public ModelとPersistence ModelはBusiness Modelに対応するが、公開や保存に必要な情報・構造はそれぞれ異なる。そのため、Business Modelそのものを公開・保存用のデータ表現として兼用することは前提としない。

データ表現の変換は、それぞれの境界を担当する要素が責任を持つ。具体的な型、変換処理、データ構造は個別設計で定義する。

## 5. Design Boundaries & Evolution

本書はBackend内部の共通構造と責務分担を記録する。具体的なディレクトリ構成、クラス、公開関数、個別の業務モデルや操作・検証ルールは、必要な設計の段階で確定する。

永続化の構造と実現方式はPersistence Architecture、FrontendとBackendの接続契約はApplication Boundary、複数の構成要素にまたがる事項はCross-cutting Concernsで扱う。システム全体の構成はOverall / System Architectureで定義する。

各Featureの設計・検証を通じてBackendの共通構造に関わる決定が生じた場合は、本書にも必要なアーキテクチャ上の決定事項を追記する。
