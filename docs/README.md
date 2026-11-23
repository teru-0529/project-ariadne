# Documentation

PROJECT ARIADNEの開発ドキュメントは、次の4領域で管理する。

## Architecture

システム全体と各構成要素の構造・責務を定義する。

- [Overview](architecture/overview.md)
- [Frontend Architecture](architecture/frontend.md)
- [Backend Architecture](architecture/backend.md)
- [Application Boundary](architecture/application-boundary.md)
- [Persistence Architecture](architecture/persistence.md)
- [Cross-cutting Concerns](architecture/cross-cutting-concerns.md)

## Requirements

Function CatalogとBehavior Mapを管理する。個別文書は作成後にリンクを追加する。

## Design

FrontendのEvent List、BackendのFunction List、および必要な詳細設計を管理する。個別文書は作成後にリンクを追加する。

## Test

Frontend／BackendそれぞれのBehavior Test Matrixを管理する。個別文書は作成後にリンクを追加する。

---

設計文書はFeature番号ではなく、設計対象や責務に応じて整理する。合意済みの現在の設計を記録し、Feature開発に合わせて拡充する。

Behavior MapはFrontend／Backendをまたぐ場合も一つのBehaviorとして管理する。各Behavior Test Matrixには、担当するBehaviorだけを記載し、担当外を示すN/Aは設けない。Frontend／Backendを接続した動作は実機で確認する。
