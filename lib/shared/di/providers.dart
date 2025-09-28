import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ramen_radar/features/ranking/data/mock_ranking_repository.dart';
import 'package:ramen_radar/features/ranking/data/google_ranking_repository.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';
import 'package:ramen_radar/shared/utils/location_service.dart';
import 'package:ramen_radar/features/ranking/presentation/map_widget.dart';

// Switch by env flag or keep mock by default for development.
final rankingRepositoryProvider = Provider<RankingRepository>((ref) {
  // Default to mock for stable UX. Explicitly enable Google API via dart-define.
  final useGoogle = const String.fromEnvironment('USE_GOOGLE_API') == 'true';
  if (useGoogle) {
    return GoogleRankingRepository();
  }
  return MockRankingRepository();
});
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

// Map widget builder provider to ease testing by overriding with a placeholder.
final mapWidgetBuilderProvider = Provider<MapWidgetBuilder>((ref) => defaultMapWidgetBuilder);

// Locale override provider; null means follow system locale.
final localeProvider = StateProvider<Locale?>((ref) => null);
