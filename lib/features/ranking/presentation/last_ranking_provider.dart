import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ramen_radar/models.dart';

final lastRankingProvider = StateProvider<List<RankingEntry>?>((ref) => null);
