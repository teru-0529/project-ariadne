# Shell — Behavior Map

<!-- markdownlint-disable MD033 -->

## B001：Welcome画面を表示する

<!-- prettier-ignore-start -->

| 項目 | 内容 |
| --- | --- |
| Precondition | なし |
| Action | アプリケーションを起動する |
| Result | **Normal**<br>・Main AreaにWelcome画面を表示する。<br>・Primary Navigationを未選択状態で表示する。<br>・FooterにApp Versionバッジを表示する。<br>・FooterにCopyrightを表示する。 |

<!-- prettier-ignore-end -->

## B002：Version詳細情報を表示する

<!-- prettier-ignore-start -->

| 項目 | 内容 |
| --- | --- |
| Precondition | AriadneShellが表示されている。 |
| Action | FooterのApp Versionバッジをクリックする。 |
| Result | **Normal**<br>・Version詳細情報のポップアップを表示する。<br>・App Version、Release Date、Schema Versionを表示する。 |

<!-- prettier-ignore-end -->
