# 共通機能 — Behavior Map

## B001：Welcome画面を表示する

**Precondition**：なし

**Action**：アプリケーションを起動する

### B001 Result / Pattern — Normal

- Main AreaにWelcome画面を表示する。
- Primary Navigationを未選択状態で表示する。
- FooterにApp Versionバッジを表示する。

## B002：Version詳細情報を表示する

**Precondition**：AriadneShellが表示されている。

**Action**：FooterのApp Versionバッジをクリックする。

### B002 Result / Pattern — Normal

- Version詳細情報のポップアップを表示する。
- App Version、Release Date、Schema Versionを表示する。
