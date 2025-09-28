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
- [ ] `.env` 運用方針の決定（`flutter_dotenv`）
- [ ] README に開発手順・API キー設定手順を追記
- [ ] GitHub Actions など CI（任意、後回し可）

---

## M1: アーキテクチャ基盤

- [ ] ディレクトリ構成の作成（README 推奨構成に準拠）
  - [ ] `lib/features/<feature>/{presentation,domain,data}`
  - [ ] `lib/shared/{utils,theme,widget,di}`
  - [ ] `lib/router`、`lib/gen`、`lib/app.dart`、`lib/main.dart`
- [ ] 主要依存関係の導入
  - [ ] 状態管理: `flutter_riverpod`, `hooks_riverpod`, `riverpod_annotation`
  - [ ] ルーティング: `auto_route`
  - [ ] モデル: `freezed`, `json_serializable`
  - [ ] DI: Riverpod（必要なら `get_it` 併用）
  - [ ] コード生成: `build_runner`
  - [ ] 環境変数: `flutter_dotenv`
  - [ ] 位置情報/権限: `geolocator`, `permission_handler`
  - [ ] マップ表示: `google_maps_flutter`
  - [ ] HTTP クライアント: `dio` or `http`（`dio` 推奨）
- [ ] `build_runner` 実行用スクリプト追加（`make`/`dart run`）
- [ ] AutoRoute 設定: ルート定義 → 生成コード確認
- [ ] Riverpod Generator 設定・サンプル Provider で疎通
- [ ] Freezed/Json のビルド確認

---

## M2: 位置情報・権限・Google API 設定

- [ ] Google Cloud プロジェクト作成・API 有効化
  - [ ] Places API
  - [ ] Distance Matrix API
  - [ ] Geocoding API
- [ ] API キー保管（`.env` → `flutter_dotenv` 読み込み）
- [ ] iOS/Android 各プラットフォーム設定
  - [ ] Google Maps API キーのネイティブ組込み
  - [ ] 位置情報権限の定義（`Info.plist`/`AndroidManifest.xml`）
- [ ] 現在地取得フロー
  - [ ] 権限リクエスト（初回/拒否時の導線）
  - [ ] 位置情報精度とタイムアウト方針
  - [ ] フォアグラウンドのみ対応（初期）

---

## M3: データ取得・スコアリング・ランキングロジック

- [ ] ドメイン設計
  - [ ] Entity: `Place`, `Score`, `RankingEntry`, `GenreTag`
  - [ ] ValueObject/Enum: `Genre`（ALL/IEKEI/JIRO）
  - [ ] DTO と相互変換（Freezed/Json）
- [ ] リポジトリ設計
  - [ ] `PlaceRepository`（検索/詳細取得）
  - [ ] `DistanceRepository`（距離取得）
  - [ ] `GeocodingRepository`（任意）
- [ ] データソース
  - [ ] Places API クライアント（キーワード/半径/型の設計）
  - [ ] Distance Matrix API クライアント（距離取得/バッチ化）
- [ ] スコアリング
  - [ ] 距離の丸め（有効数字2桁。1km未満はそのまま）
  - [ ] `総合スコア = (rating × 2) − distance(km)` のユースケース
  - [ ] 同点時の順位決定ルール（距離優先など）
- [ ] ランキング生成
  - [ ] 上位10件の抽出
  - [ ] 並び替え/タイブレーク/欠損値の扱い
  - [ ] キャッシュ（API 回数と待ち時間削減）

---

## M4: UI（ランキング/地図/スポット評価）

- [ ] 画面構成
  - [ ] Home（ジャンル切替: ALL/IEKEI/JIRO）
  - [ ] ランキングリスト（スコア/距離/タグ表示）
  - [ ] 地図ビュー（ピン/選択/詳細）
  - [ ] 詳細モーダル or 詳細画面（任意）
- [ ] 地図とリストのシームレス切替（トグル/タブ）
- [ ] スポット評価（上位10の平均 → S/A/B/C/D 表示）
- [ ] ローディング/エラーステート（再試行/権限誘導）
- [ ] デザイン（シンプル/視認性/高速操作）

---

## M5: i18n・テーマ・アクセシビリティ

- [ ] `gen_l10n` 設定（`flutter_localizations`/`intl`）
- [ ] 文言分離・多言語リソース整備（ja/en から開始）
- [ ] ダークモード/カラー/タイポ整理（`shared/theme`）
- [ ] アクセシビリティ（フォントサイズ/コントラスト/タップ領域）

---

## M6: キャッシュ/パフォーマンス

- [ ] Places/Distance 応答の短期キャッシュ（メモリ or `hive` 任意）
- [ ] バッチ/レート制御（Distance Matrix はまとめて問い合わせ）
- [ ] ローディング体験改善（スケルトン/UI プレースホルダ）
- [ ] 位置更新しすぎの抑制（しきい値/時間間隔）

---

## M7: テスト

- [ ] ユニットテスト
  - [ ] スコア計算/距離丸め/ランク付け
  - [ ] スポット評価（S〜D 境界テスト）
  - [ ] ジャンルフィルタの判定
- [ ] ウィジェットテスト
  - [ ] リスト/地図切替の状態遷移
  - [ ] ローディング/エラー表示
- [ ] リポジトリのモックテスト（API 失敗/欠損）

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
- [ ] 依存関係追加/設定（Riverpod/AutoRoute/Freezed/Json/build_runner/dotenv）
- [ ] Lint/Analyzer/フォーマッタ設定

2) 基盤
- [ ] ルーティング雛形（Home/Detail）
- [ ] Provider 雛形（位置/ランキング）
- [ ] テーマ/ローカライズ下準備

3) 位置情報/権限
- [ ] 権限ダイアログ/ハンドリング
- [ ] 現在地の取得（失敗パス含む）

4) API クライアント
- [ ] Places 検索
- [ ] Distance Matrix 距離取得（バッチ）

5) ドメイン/ユースケース
- [ ] DTO/Entity 生成（Freezed/Json）
- [ ] スコアリング/並び替え/10件抽出
- [ ] スポット評価（S/A/B/C/D）

6) UI
- [ ] ジャンル切替（ALL/IEKEI/JIRO）
- [ ] ランキングリスト（スコア/距離/タグ）
- [ ] 地図表示/ピン/選択
- [ ] リスト⇄地図切替

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
