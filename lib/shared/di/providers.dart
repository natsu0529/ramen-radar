import 'package/flutter_riverpod/flutter_riverpod.dart';

import '../../features/ranking/data/mock_ranking_repository.dart';
import '../../features/ranking/domain/ranking_repository.dart';
import '../utils/location_service.dart';

final rankingRepositoryProvider = Provider<RankingRepository>((ref) => MockRankingRepository());
final locationServiceProvider = Provider<LocationService>((ref) => LocationService());
