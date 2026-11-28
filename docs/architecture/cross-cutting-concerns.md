# Cross-cutting Concerns

## 1. Architecture Principles

本書は、Frontend、Backend、Application Boundary、Persistenceにまたがる共通的な関心事を扱う。

- 各Architectureで確定した責務分担を前提とし、本書で再定義しない。
- 複数の構成要素が連携する際の共通方針を明確にする。
- 業務ルールや個別Featureの実装方法は、それぞれの責務を持つ設計に委ねる。
- 共通方針と具体的な実装方式を区別する。

## 2. Error Handling

エラーは、発生箇所で把握した内容を、各構成要素の責務に従って呼び出し元へ伝達する。

- Business Modelは、業務上のルールと整合性を管理する。
- Backend内部のエラー変換は、Application Boundaryで定義した責務分担に従う。
- Frontendは受け取ったエラーを、画面の状態や操作に応じて表示する。
- エラーの表示方法は、既存のFrontendの方針に従い、必要に応じてフィールド表示やToastを使い分ける。

エラーの分類や伝達に関する共通原則は維持し、個別のエラーコード、メッセージ、表示条件は必要な設計段階で具体化する。

## 3. Logging

ログは、アプリケーションの処理状況や問題の調査に必要な情報を記録するために利用する。

- Backend Boundaryにおけるログ出力は、Application Boundaryで定義した責務に従う。
- ログ出力とユーザーへのエラー通知は、目的の異なる処理として区別する。
- ログの内容は、問題の原因や発生箇所を追跡できることを重視する。
- ログの形式、出力先、詳細度などの具体的な方式は、必要な設計段階で定める。

## 4. Asynchronous Processing

非同期処理では、操作の受付と処理結果の確定を区別する。

- 保存、生成、画面更新など、連続して実行される処理の成功・失敗は、それぞれの責務に応じて扱う。
- `ariadne.yaml`の保存成功と、DDL・OASなどの生成成功は別の結果として扱う。
- 保存、再読み込み、Workspace切替を契機とする生成処理は非同期に実行する。
- Frontendに通知する状態や結果は、利用者が操作の結果を判断できるようにする。

具体的な実行制御、競合時の扱い、通知方法は、対象となるFeatureの設計で定める。

## 5. Configuration & Lifecycle

アプリケーションの設定とWorkspaceの状態は、それぞれの責務を区別して扱う。

- ユーザー領域の`configure.yaml`は、ConfigureService／ConfigurePortを介して利用する。
- Workspaceのデータは、選択された`ariadne.yaml`を正本とする。
- Workspace切替時および再読み込み時には、対象Workspaceに対応するデータと状態を扱う。
- Workspace単位の外部変更検知は、Persistence Architectureで定義したHash管理の方針に従う。

設定の保存先や読み書きの具体的な構造はPersistence Architecture、画面の遷移や表示状態はFrontend Architectureおよび各Featureの設計で扱う。

## 6. Versioning

アプリケーションのバージョンと保存データのスキーマバージョンは、別の概念として管理する。

<!-- prettier-ignore-start -->

| 区分 | 役割 | 形式 |
| --- | --- | --- |
| App Version | アプリケーションのリリースを識別する | `1.1.1`形式 |
| Schema Version | `ariadne.yaml`のデータ構造のバージョンを識別する | `1.1`形式 |

<!-- prettier-ignore-end -->

- App VersionとSchema Versionは、アプリケーションのFooterに表示する。
- Schema Versionは`ariadne.yaml`に記録する。
- 両者の更新は、それぞれの変更対象に応じて判断する。
- Schema VersionのMajor更新では、下位互換性を保証しないことを基本方針とする。

バージョン間の互換性や移行方法は、必要な設計段階で定める。

## 7. Design Boundaries & Evolution

本書は、エラー処理、ログ、非同期処理、設定とライフサイクル、バージョン管理について、Architectureを横断する共通方針を定義する。

各構成要素の具体的な責務は、Frontend Architecture、Backend Architecture、Application Boundary、Persistence Architectureに従う。

個別Featureの処理手順、画面表示、データ型、実装方式は、本書で一律に規定しない。

各Featureの設計・検証を通じて横断的な共通方針が確定した場合は、本書に必要な決定事項を追記する。
