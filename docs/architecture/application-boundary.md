# Application Boundary Architecture

## 1. Architecture Principles

Application Boundaryは、FrontendとBackendの接続構造および責務境界を定義する。

- FrontendとBackendはWails Bindingを介して接続する。
- 境界を越える要求・応答のデータ表現にはPublic Modelを使用する。
- FrontendはBackend内部のBusiness ModelやPersistence Modelに直接依存しない。
- BackendはFrontendの画面表示方法を決定しない。

## 2. Logical Structure

| 要素 | 責務 |
|---|---|
| Frontend | Backendへの要求と、受け取った結果の利用 |
| Wails Binding | Goで定義したBackend側Boundaryを基に、Wailsが自動生成するTypeScriptの呼び出しコード |
| Store | Backendからの取得と取得結果の保持 | 
| Frontend Domain Model | 生成時（`new`）にWails生成モデルをFrontend内部モデルへ変換する |
| Wails Boundary | FrontendとBackendの呼び出しを接続する |
| Backend側Boundary | 要求時のPublic ModelからApplication ServiceのIFに合わせた形式への変換、エラー変換、ログ出力 |
| Application Service | 要求に応じた処理の実行と結果の返却 |
| Public Model | FrontendとBackendの境界を越えるデータ表現 |

Frontendからの呼び出しは、Wails Binding、Wails Boundary、Backend側Boundaryを経由してBackendのApplication Serviceへ接続する。

## 3. Data Boundary

| 項目 | 基本方針 |
|---|---|
| 要求データ | FrontendからBackendへ渡すデータはPublic Modelで表現する |
| 応答データ | BackendからFrontendへ返すデータはPublic Modelで表現する |
| 要求時の変換（Backend側） | Backend側BoundaryがPublic ModelをApplication ServiceのIFに合わせた形式へ変換する。IFには`any`型も含まれるため、変換先を特定のモデルに限定しない |
| 応答時の変換（Frontend側） | Frontend Domain Modelが生成時（`new`）にWails生成モデルからFrontend内部モデルへ変換する。型定義上は`nil`を許容するが、業務上は`nil`にならない値についても、この変換で扱う |

## 4. Responsibility & Error Boundary

Application Serviceは要求に応じた処理を実行し、結果を返す。Frontendは受け取った結果を利用し、画面の状態や表示を制御する。

Backend側Boundaryは、Backend内部のエラーをFrontendが解釈できる形式へ変換し、ログを出力する。Backend内部のエラー表現をそのまま公開することは前提としない。

Frontendは受け取ったエラーをToastで通知する。BackendはToastの表示を直接制御しない。

## 5. Design Boundaries & Evolution

本書はFrontendとBackendの接続構造、データ表現、責務とエラーの境界を記録する。個別の業務機能、呼び出しメソッド、具体的な型、エラーコード体系、変換処理の実装方法は、必要な設計の段階で確定する。

Frontend内部の構造はFrontend Architecture、Backend内部の構造はBackend Architectureで扱う。

個別設計・検証を通じて接続境界に関わる共通的な決定が生じた場合は、本書にも必要なアーキテクチャ上の決定事項を追記する。
