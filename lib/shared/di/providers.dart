import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

import 'package:ramen_radar/features/ranking/data/google_ranking_repository.dart';
import 'package:ramen_radar/features/ranking/data/mock_ranking_repository.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';
import 'package:ramen_radar/shared/utils/location_service.dart';
import 'package:ramen_radar/features/ranking/presentation/map_widget.dart';

// Switch by env flag or keep mock by default for development.
final rankingRepositoryProvider = Provider<RankingRepository>((ref) {
  // Check runtime environment variable from dotenv or system environment
  final useGoogleFromEnv = dotenv.env['USE_GOOGLE_API']?.toLowerCase() == 'true';
  const useGoogleFromSystem = bool.fromEnvironment('USE_GOOGLE_API');
  final useGoogle = useGoogleFromEnv || useGoogleFromSystem;
  
  developer.log('DEBUG: USE_GOOGLE_API from dotenv: ${dotenv.env['USE_GOOGLE_API']}');
  developer.log('DEBUG: USE_GOOGLE_API from system: $useGoogleFromSystem');
  developer.log('DEBUG: Using Google API: $useGoogle');
  
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
