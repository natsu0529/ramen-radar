# 実装計画（Ramen Radar）

本ドキュメントは README の要件をもとに、実装タスクを可能な限りブレイクダウンしたチェックリストです。上から順に進めることで、依存関係を踏まえた安全な実装ができます。

---

## ゴール

- [ ] 現在地を起点にした「オール/家系/二郎系」3ジャンルのランキング表示（各10件）
- [ ] 独自スコア（(Google評価×2) − 距離(km)）の算出と表示
- [ ] 上位10件の平均スコアによるスポット評価（S/A/B/C/D）の表示
- [ ] 地図とランキングのシームレスな切り替え
- [ ] 多言語対応（gen_l10n）

---

## マイルストーン

- [ ] M0: プロジェクト初期化・開発環境整備
- [ ] M1: アーキテクチャ基盤（DI/Router/State/Model/Codegen）
- [ ] M2: 位置情報・権限・Google API 設定
- [ ] M3: データ取得・スコアリング・ランキングロジック
- [ ] M4: UI（ランキング/地図切替/スポット評価）
- [ ] M5: i18n・テーマ・アクセシビリティ
- [ ] M6: キャッシュ/パフォーマンス最適化
- [ ] M7: テスト整備（ユニット/ウィジェット）
- [ ] M8: ストア配布準備/ドキュメント整備

---

## M0: プロジェクト初期化・開発環境整備

- [ ] Flutter 環境確認（Flutter/Dart バージョン固定、`fvm` 必須）
- [ ] 新規 Flutter アプリ雛形作成 or 既存プロジェクト整合確認
- [ ] `flutter_lints` 導入とアナライザ設定（`analysis_options.yaml`）
- [x] `.env` 運用方針の決定（`flutter_dotenv`）と `.env.example` 追加
- [x] 開発手順ドキュメント追加（`docs/DEVELOPMENT.md`）
- [ ] GitHub Actions など CI（任意、後回し可）

---

## M1: アーキテクチャ基盤

- [x] ディレクトリ構成の作成（README 推奨構成に準拠）
  - [x] `lib/features/<feature>/{presentation,domain,data}`（`ranking` を追加）
  - [x] `lib/shared/{utils,theme,widget,di}`
  - [x] `lib/router`、`lib/gen`、`lib/app.dart`、`lib/main.dart`
 - [ ] 主要依存関係の導入
  - [x] 状態管理: `flutter_riverpod`, `hooks_riverpod`, `riverpod_annotation`
  - [x] ルーティング: `auto_route`（導入のみ）
  - [x] モデル: `freezed`, `json_serializable`（導入のみ）
  - [x] DI: Riverpod
  - [x] コード生成: `build_runner`（導入のみ）
  - [x] 環境変数: `flutter_dotenv`
  - [x] 位置情報/権限: `geolocator`, `permission_handler`
  - [x] マップ表示: `google_maps_flutter`（導入のみ）
  - [x] HTTP クライアント: `dio`
- [ ] `build_runner` 実行用スクリプト追加（`make`/`dart run`）
- [ ] AutoRoute 設定: ルート定義 → 生成コード確認
- [x] Riverpod Provider 雛形で疎通（モックリポジトリ）
- [ ] Freezed/Json のビルド確認

---

## M2: 位置情報・権限・Google API 設定

- [ ] Google Cloud プロジェクト作成・API 有効化
  - [ ] Places API
  - [ ] Distance Matrix API
  - [ ] Geocoding API
- [x] API キー保管（`.env` → `flutter_dotenv` 読み込み）
- [ ] iOS/Android/Web 各プラットフォーム設定
  - [ ] Google Maps API キーのネイティブ組込み
  - [ ] 位置情報権限の定義（`Info.plist`/`AndroidManifest.xml`）
- [x] 反映スクリプトの用意（`scripts/inject_maps_keys.dart`）
- [x] 現在地取得フロー
  - [x] 権限リクエスト（初回/拒否時の導線）
  - [x] 位置情報精度とタイムアウト方針
  - [x] フォアグラウンドのみ対応（初期）

---

## M3: データ取得・スコアリング・ランキングロジック

- [x] ドメイン設計（初期簡易実装）
  - [x] Entity: `Place`, `RankingEntry`, `RamenTag`（`lib/models.dart`）
  - [x] ValueObject/Enum: `Genre`（ALL/IEKEI/JIRO）
  - [x] DTO と相互変換（Freezed/Json）
- [ ] リポジトリ設計
  - [ ] `PlaceRepository`（検索/詳細取得）
  - [ ] `DistanceRepository`（距離取得）
  - [ ] `GeocodingRepository`（任意）
 - [ ] データソース
  - [x] Places API クライアント（キーワード/半径/型の設計）
  - [x] Distance Matrix API クライアント（距離取得/バッチ化）
  
 進捗（実装）
- [x] Google API リポジトリ実装（`GoogleRankingRepository`）
- [x] Places API/Distance Matrix API クライアント（`google_apis.dart`）
- [ ] Geocoding API（未）
- [x] DTO（Freezed/Json）
- [x] スコアリング
  - [x] 距離の丸め（有効数字2桁。1km未満はそのまま）
  - [x] `総合スコア = (rating × 2) − distance(km)` のユースケース
  - [x] 同点時の順位決定ルール（距離優先など）
- [x] ランキング生成
  - [x] 上位10件の抽出
  - [x] 並び替え/タイブレーク/欠損値の扱い（欠損は未対応）
  - [ ] キャッシュ（API 回数と待ち時間削減）

---

## M4: UI（ランキング/地図/スポット評価）

- [x] 画面構成（初期雛形）
  - [x] Home（ジャンル切替: ALL/IEKEI/JIRO）
  - [x] ランキングリスト（スコア/距離/タグ表示）
  - [x] 地図ビュー（ピン表示）
  - [x] 詳細モーダル（ボトムシート）
 - [x] 地図とリストのシームレス切替（トグル）
 - [x] スポット評価（上位10の平均 → S/A/B/C/D 表示）
 - [x] ローディング/エラーステート（再試行/権限誘導）
 - [ ] デザイン（シンプル/視認性/高速操作）

---

## M5: i18n・テーマ・アクセシビリティ

- [x] `gen_l10n` 設定（`flutter_localizations`/`l10n.yaml`）
- [x] 文言分離・多言語リソース整備（ja/en から開始）
- [x] テーマ基盤（`shared/theme/app_theme.dart`）
- [x] アクセシビリティ（主要操作の Semantics ラベル付与）
- [ ] フォントサイズ/コントラスト/タップ領域の最適化

---

## M6: キャッシュ/パフォーマンス

- [ ] Places/Distance 応答の短期キャッシュ（メモリ or `hive` 任意）
- [ ] バッチ/レート制御（Distance Matrix はまとめて問い合わせ）
- [ ] ローディング体験改善（スケルトン/UI プレースホルダ）
- [ ] 位置更新しすぎの抑制（しきい値/時間間隔）

---

## M7: テスト

- [x] ユニットテスト
  - [x] スコア計算/距離丸め/ランク付け（`test/scoring_test.dart`）
  - [x] スポット評価（S〜D 境界テスト）
  - [ ] ジャンルフィルタの判定
- [ ] ウィジェットテスト
  - [x] リスト表示（データ反映）
  - [x] 地図切替の状態遷移（ビルダー差し替えで検証）
  - [x] ローディング/エラー表示（位置権限/ランキング取得失敗）
  - [ ] リポジトリのモックテスト（欠損/エッジケース）

---

## M8: ストア配布準備/ドキュメント

- [ ] アプリアイコン/スプラッシュ
- [ ] プライバシーポリシー（位置情報/外部 API 利用）
- [ ] README 更新（スクショ/使い方/権限/既知の制約）
- [ ] バージョニング/リリースノート

---

## 詳細タスク（補足）

### ジャンル判定（家系/二郎系）
- [ ] 仮実装: 店名/カテゴリ/レビュー文からのキーワード判定
- [ ] 将来: 管理用リスト or ルールベース/ML の導入検討

### Google スプレッドシートへのエクスポート（任意）
- [ ] 方式検討（Sheets API or Apps Script Webhook）
- [ ] 上位10件のエクスポート/シート整形
- [ ] ユーザー操作（共有/エクスポートUI）

### エラーハンドリング/UX
- [ ] 位置権限拒否時の案内（設定アプリへ）
- [ ] API 失敗時の再試行/フォールバック（距離=Haversine）
- [ ] オフライン時の案内/最後の結果表示

### ログ/監視（任意）
- [ ] ユーザーレポート（`firebase_crashlytics` 等）
- [ ] 最低限の操作ログ（プライバシー配慮）

---

## 実装順チェックリスト（短縮版）

1) 初期化
- [x] 依存関係追加/設定（Riverpod/AutoRoute/Freezed/Json/build_runner/dotenv）
- [x] Lint/Analyzer/フォーマッタ設定

2) 基盤
- [x] ルーティング雛形（Home のみ）
- [x] Provider 雛形（ランキング）
- [ ] テーマ/ローカライズ下準備

3) 位置情報/権限
- [ ] 権限ダイアログ/ハンドリング
- [ ] 現在地の取得（失敗パス含む）

4) API クライアント
- [ ] Places 検索
- [ ] Distance Matrix 距離取得（バッチ）

5) ドメイン/ユースケース
- [x] DTO/Entity 生成（Freezed/Json）
- [x] スコアリング/並び替え/10件抽出
- [x] スポット評価（S/A/B/C/D）

6) UI
- [x] ジャンル切替（ALL/IEKEI/JIRO）
- [x] ランキングリスト（スコア/距離/タグ）
- [x] 地図表示/ピン
- [x] リスト⇄地図切替

7) 仕上げ
- [ ] i18n 文言分離
- [ ] キャッシュ/レート制御
- [ ] テスト一式
- [ ] README/スクショ更新

---

## コマンド（目安）

- `dart run build_runner build --delete-conflicting-outputs`
- `flutter pub run build_runner watch --delete-conflicting-outputs`

---

## 既知のリスク/検討事項

- [ ] Places のレスポンスだけでは家系/二郎系の厳密判定が難しい（暫定キーワード方式）
- [ ] Distance Matrix の課金/レート制限（バッチ/キャッシュ前提）
- [ ] 位置情報の取得安定性（端末/設定差）
- [ ] マップ SDK のプラットフォーム差異（UI/権限）

---

この計画は進捗に応じて随時更新してください。
