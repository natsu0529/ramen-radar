import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models.dart';

final lastRankingProvider = StateProvider<List<RankingEntry>?>((ref) => null);

