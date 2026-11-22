# Documentation

PROJECT ARIADNEの開発ドキュメントは、次の4領域で管理する。

| 領域 | 内容 |
|---|---|
| [Architecture](architecture/) | システム全体・Frontend・Backend・Boundary・Persistence・横断的関心事の構造と責務 |
| [Requirements](requirements/) | Function CatalogとBehavior Map |
| [Design](design/) | FrontendのEvent List、BackendのFunction List、および必要な詳細設計 |
| [Test](test/) | Frontend／BackendそれぞれのBehavior Test Matrix |

設計文書はFeature番号ではなく、設計対象や責務に応じて整理する。合意済みの現在の設計を記録し、Feature開発に合わせて拡充する。

Behavior MapはFrontend／Backendをまたぐ場合も一つのBehaviorとして管理する。各Behavior Test Matrixには、担当するBehaviorだけを記載し、担当外を示すN/Aは設けない。Frontend／Backendを接続した動作は実機で確認する。

各領域の個別文書は、整備した時点でリンクを追加する。
