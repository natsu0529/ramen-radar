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

## 実行（目安）

```bash
flutter pub get
flutter run
```

## 備考

- 初期段階では UI よりもコアロジック（スコア/ランキング）を先に仕上げると安全です。
- Distance Matrix のレート制限に注意し、距離問い合わせはバッチ化/キャッシュを推奨。

