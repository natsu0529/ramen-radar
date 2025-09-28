import 'package/flutter_riverpod/flutter_riverpod.dart';

import '../../features/ranking/data/mock_ranking_repository.dart';
import '../../features/ranking/domain/ranking_repository.dart';

final rankingRepositoryProvider = Provider<RankingRepository>((ref) => MockRankingRepository());
