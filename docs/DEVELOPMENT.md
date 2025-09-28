# 開発手順と環境セットアップ

このドキュメントは README の「開発環境のセットアップ」を具体化したものです。まずは API キーと Flutter 環境の準備から始め、後続の依存関係やコード生成を進めます。

## 前提

- Flutter SDK がローカルにインストール済み（安定版推奨）
- Google Cloud プロジェクト作成済み

## Google Maps Platform 設定

1. 有効化する API
   - Places API
   - Distance Matrix API
   - Geocoding API
2. API キーを発行し、アプリ用に制限（HTTP リファラ/アプリ署名）
3. ルート直下の `.env` に設定

```
GOOGLE_MAPS_API_KEY="あなたのAPIキー"
```

## iOS/Android ネイティブ設定（概要）

- iOS: `ios/Runner/Info.plist`
  - `io.flutter.embedded_views_preview` を有効
  - `GMSApiKey` もしくは `Application Scene Manifest` 配下で `GMSApiKey` を埋め込み

- Android: `android/app/src/main/AndroidManifest.xml`
  - `<application>` に `com.google.android.geo.API_KEY` の `meta-data` を追加

## 依存関係（例）

`pubspec.yaml` の dependencies に以下を追加（実プロジェクト化後）

- 状態管理: `flutter_riverpod`, `hooks_riverpod`, `riverpod_annotation`
- ルーティング: `auto_route`
- モデル: `freezed`, `json_serializable`
- DI/Utility: `get_it`（任意）
- コード生成: `build_runner`
- 環境変数: `flutter_dotenv`
- 位置情報/権限: `geolocator`, `permission_handler`
- マップ表示: `google_maps_flutter`
- 通信: `dio`

## コード生成

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### ローカライズ生成（gen_l10n）

```bash
fvm flutter gen-l10n
```
もしくは `flutter run` 時に自動生成されます。

## 実行（目安）

```bash
flutter pub get
flutter run
```

## プラットフォーム生成と Google Maps API キー反映

最初にプラットフォームを生成します（Android/iOS/Web）。

```bash
fvm flutter create . --platforms=android,ios,web
```

API キーは `.env` の `GOOGLE_MAPS_API_KEY` を使用します。以下のスクリプトで各プラットフォームに反映できます。

```bash
fvm dart run scripts/inject_maps_keys.dart
```

補足:
- Android: `android/app/build.gradle` に `manifestPlaceholders`、`AndroidManifest.xml` に `<meta-data>` が挿入されます。
- iOS: `ios/Runner/Info.plist` に `GMSApiKey` と `NSLocationWhenInUseUsageDescription` が挿入されます。
- Web: `web/index.html` に Google Maps JS API の `<script>` タグが追加されます。

その後、デバイスを指定して起動します。

```bash
fvm flutter devices
fvm flutter run -d <device-id>
```

## アイコン/スプラッシュ生成

`assets/icons/app_icon.png` を配置したうえで、以下のコマンドを実行します。

```bash
fvm flutter pub run flutter_launcher_icons
fvm flutter pub run flutter_native_splash:create
```

※ プラットフォームフォルダ（`android/`, `ios/` など）が必要です。

## スクリーンショット

`docs/screenshots/` に端末別のスクリーンショットを配置してください。
- 推奨: `home_list.png`, `home_map.png`, `detail_sheet.png`

## リリース手順（概要）

1. バージョン更新（`pubspec.yaml`）と `docs/RELEASE_NOTES.md` 追記
2. アイコン/スプラッシュ反映（上記コマンド）
3. スクショ撮影・`README.md` への掲載
4. ストア用設定（アプリ名/バンドルID/署名 等）
5. 配布前の最終動作確認（API キー/権限/リージョン設定）

## Google API 実装の切替（任意）

デフォルトはモックデータを使用します。Google API 実装を使用する場合は、`dart-define` を指定してください。

```bash
fvm flutter run --dart-define=USE_GOOGLE_API=true -d <device-id>
```

`.env` に `GOOGLE_MAPS_API_KEY` が設定されている必要があります。API 呼び出し前に `scripts/inject_maps_keys.dart` の実行も推奨です。

## 備考

- 初期段階では UI よりもコアロジック（スコア/ランキング）を先に仕上げると安全です。
- Distance Matrix のレート制限に注意し、距離問い合わせはバッチ化/キャッシュを推奨。
