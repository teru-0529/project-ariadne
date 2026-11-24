# Application Shell

## 1. Shell Layout

Application Shellは、Header、Primary Navigation、Feature Area、Footerで構成する。

Feature Areaのみを切り替え、その他の領域は共通して表示する。

## 2. Primary Navigation

起動時はPrimary Navigationは未選択、Feature AreaにはWelcome画面を表示する。

Primary NavigationからElements、DB、API、Configを選択すると、対応する画面をFeature Areaに表示する。選択後は、常にいずれかのFeatureが選択された状態とする。

Featureの選択状態はShell内で管理する。

## 3. Version Information

FooterにApp Versionを表示する。クリックするとPopupを開き、Version情報を表示する。

Version情報のうち、App VersionとRelease Dateはビルド時に確定する。Schema VersionはYAMLの読み書きを担当するAdapterが保持する。

BackendはVersion情報を集約して公開し、Frontendは起動時に非同期で取得する。
