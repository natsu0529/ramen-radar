// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Ramen Radar';

  @override
  String get genreAll => '全て';

  @override
  String get genreIekei => '家系';

  @override
  String get genreJiro => '二郎系';

  @override
  String get list => 'リスト';

  @override
  String get map => '地図';

  @override
  String get spotGradeLabel => 'スポット評価';

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String rating(Object rating) {
    return '評価 $rating';
  }

  @override
  String score(Object score) {
    return '$score';
  }

  @override
  String get errorRankingFetch => 'ランキングの取得に失敗しました';

  @override
  String get retry => '再試行';

  @override
  String get openSettings => '設定を開く';

  @override
  String get openInMaps => '地図アプリで開く';

  @override
  String get errorLocationServiceDisabled => '位置情報サービスが無効です。端末の設定を確認してください。';

  @override
  String get errorPermissionDenied => '位置情報の権限が拒否されました。許可してください。';

  @override
  String get errorPermissionDeniedForever =>
      '位置情報の権限が恒久的に拒否されています。設定から許可してください。';

  @override
  String get errorTimeout => '現在地の取得がタイムアウトしました。再試行してください。';

  @override
  String get errorLocationGeneric => '現在地の取得に失敗しました';

  @override
  String get offline => 'オフライン';

  @override
  String get showingLastResults => '最後の結果を表示中';

  @override
  String mapViewA11y(Object count) {
    return '$count件の結果を表示する地図ビュー';
  }

  @override
  String get refresh => '更新';
}
