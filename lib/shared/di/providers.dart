import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/ranking/data/mock_ranking_repository.dart';
import '../../features/ranking/data/google_ranking_repository.dart';
import '../../features/ranking/domain/ranking_repository.dart';
import '../utils/location_service.dart';
import '../../features/ranking/presentation/map_widget.dart';

// Switch by env flag or keep mock by default for development.
final rankingRepositoryProvider = Provider<RankingRepository>((ref) {
  final useGoogle = const String.fromEnvironment('USE_GOOGLE_API') == 'true';
  // If dart-define USE_GOOGLE_API=true is set at build/run time, use Google API implementation.
  return useGoogle ? GoogleRankingRepository() : MockRankingRepository();
});
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

// Map widget builder provider to ease testing by overriding with a placeholder.
final mapWidgetBuilderProvider = Provider<MapWidgetBuilder>((ref) => defaultMapWidgetBuilder);
