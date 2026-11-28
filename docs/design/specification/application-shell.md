# Application Shell

## 1. Shell Layout

Application Shellは、Header、Primary Navigation、Feature Area、Footerで構成する。

Feature Areaのみを切り替え、その他の領域は共通して表示する。

## 2. Primary Navigation

起動時はPrimary Navigationは未選択、Feature AreaにはWelcome画面を表示する。

Primary NavigationからElements、DB、API、Configを選択すると、対応する画面をFeature Areaに表示する。選択後は、常にいずれかのFeatureが選択された状態とする。

Featureの選択状態はShell内で管理する。

## 3. Version Information

FooterにApp Versionを表示する。クリックするとPopupを開き、詳細情報を表示する。

詳細情報には、ビルド時に確定するApp VersionとRelease Date、YAMLの読み書きを担当するAdapterが保持するSchema Versionが含まれる。

Backendはこれらをアプリケーション情報として集約・公開し、Frontendは起動時に非同期で取得する。

## 4. Copyright

FooterにCopyrightを表示する。

開始年は2026年とし、終了年はアプリケーション情報のRelease Dateから導出する。同一年の場合は単年表記とする。
