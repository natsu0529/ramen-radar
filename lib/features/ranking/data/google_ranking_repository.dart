import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../models.dart';
import '../domain/ranking_repository.dart';
import 'google_apis.dart';

class GoogleRankingRepository implements RankingRepository {
  GoogleRankingRepository({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(),
        _apiKey = apiKey ?? dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  final Dio _dio;
  final String _apiKey;

  @override
  Future<List<Candidate>> fetchCandidates({required Genre genre, required LatLng current}) async {
    if (_apiKey.isEmpty) {
      // Fallback to empty when API key missing
      return const [];
    }
    final placesApi = GooglePlacesApi(_dio, apiKey: _apiKey);
    final distApi = GoogleDistanceMatrixApi(_dio, apiKey: _apiKey);

    final places = await placesApi.searchNearbyRamen(current: current, genre: genre);
    // Respect Distance Matrix element limits (25 per origin on free tier); truncate to top 25 by rating
    final limited = [...places]..sort((a, b) => b.rating.compareTo(a.rating));
    final top = limited.take(25).toList();

    final distances = await distApi.distancesKm(
      origin: current,
      destinations: top.map((p) => p.location).toList(),
      mode: 'walking',
    );
    final result = <Candidate>[];
    for (var i = 0; i < top.length && i < distances.length; i++) {
      final d = distances[i];
      if (d.isNaN || d.isInfinite) continue;
      result.add(Candidate(place: top[i], distanceKm: d));
    }
    return result;
  }
}

