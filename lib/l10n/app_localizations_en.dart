// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:ramen_radar/l10n/app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ramen Radar';

  @override
  String get genreAll => 'ALL';

  @override
  String get genreIekei => 'Iekei';

  @override
  String get genreJiro => 'Jiro';

  @override
  String get list => 'List';

  @override
  String get map => 'Map';

  @override
  String get spotGradeLabel => 'Spot grade';

  @override
  String distanceKm(Object distance) {
    return '$distance km';
  }

  @override
  String rating(Object rating) {
    return 'Rating $rating';
  }

  @override
  String score(Object score) {
    return '$score';
  }

  @override
  String get errorRankingFetch => 'Failed to fetch ranking';

  @override
  String get retry => 'Retry';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get errorLocationServiceDisabled =>
      'Location service is disabled. Please enable it in system settings.';

  @override
  String get errorPermissionDenied =>
      'Location permission denied. Please allow it.';

  @override
  String get errorPermissionDeniedForever =>
      'Location permission permanently denied. Please allow it in Settings.';

  @override
  String get errorTimeout =>
      'Getting current location timed out. Please retry.';

  @override
  String get errorLocationGeneric => 'Failed to get current location';

  @override
  String get offline => 'Offline';

  @override
  String get showingLastResults => 'Showing last results';

  @override
  String mapViewA11y(Object count) {
    return 'Map view with $count results';
  }

  @override
  String get refresh => 'Refresh';
}
