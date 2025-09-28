import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/shared/utils/ttl_cache.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';
import 'package:ramen_radar/features/ranking/data/google_apis.dart';

class GoogleRankingRepository implements RankingRepository {
  GoogleRankingRepository({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(),
        _apiKey = apiKey ?? dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  final Dio _dio;
  final String _apiKey;
  final _placesCache = TtlCache<List<Place>>();
  final _distanceCache = TtlCache<double>(); // key: originBucket|placeId -> km

  @override
  Future<List<Candidate>> fetchCandidates({required Genre genre, required LatLng current}) async {
    if (_apiKey.isEmpty) {
      // Fallback to empty when API key missing
      return const [];
    }
    final placesApi = GooglePlacesApi(_dio, apiKey: _apiKey);
    final distApi = GoogleDistanceMatrixApi(_dio, apiKey: _apiKey);
    final originBucket = _bucketLatLng(current);
    final placesKey = 'nearby:${genre.name}:$originBucket:2000';
    var places = _placesCache.get(placesKey);
    places ??= await placesApi.searchNearbyRamen(current: current, genre: genre);
    _placesCache.set(placesKey, places, ttl: const Duration(minutes: 3));
    // Respect Distance Matrix element limits (25 per origin on free tier); truncate to top 25 by rating
    final limited = [...places]..sort((a, b) => b.rating.compareTo(a.rating));
    final top = limited.take(25).toList();

    // Distances with per-destination cache
    final result = <Candidate>[];
    final missingIdx = <int>[];
    final missingDest = <LatLng>[];
    final distancesKm = List<double>.filled(top.length, double.nan);
    for (var i = 0; i < top.length; i++) {
      final pid = top[i].id;
      final key = 'dist:$originBucket:$pid';
      final cached = _distanceCache.get(key);
      if (cached == null) {
        missingIdx.add(i);
        missingDest.add(top[i].location);
      } else {
        distancesKm[i] = cached;
      }
    }

    if (missingDest.isNotEmpty) {
      final fetched = await distApi.distancesKm(origin: current, destinations: missingDest, mode: 'walking');
      for (var j = 0; j < missingIdx.length && j < fetched.length; j++) {
        final i = missingIdx[j];
        final d = fetched[j];
        distancesKm[i] = d;
        final pid = top[i].id;
        _distanceCache.set('dist:$originBucket:$pid', d, ttl: const Duration(minutes: 3));
      }
    }

    for (var i = 0; i < top.length; i++) {
      var d = distancesKm[i];
      if (d.isNaN || d.isInfinite) {
        // Fallback to Haversine distance if API failed
        d = _haversineKm(current, top[i].location);
      }
      result.add(Candidate(place: top[i], distanceKm: d));
    }
    return result;
  }

  String _bucketLatLng(LatLng p) {
    // Round to 3 decimals (~110m) to increase cache hit around same area
    double r(double v) => (v * 1000).roundToDouble() / 1000.0;
    return '${r(p.lat)},${r(p.lng)}';
  }

  double _haversineKm(LatLng a, LatLng b) {
    const r = 6371.0;
    final dLat = _deg2rad(b.lat - a.lat);
    final dLon = _deg2rad(b.lng - a.lng);
    final aa =
        (Maths.sin(dLat / 2) * Maths.sin(dLat / 2)) +
            Maths.cos(_deg2rad(a.lat)) *
                Maths.cos(_deg2rad(b.lat)) *
                (Maths.sin(dLon / 2) * Maths.sin(dLon / 2));
    final c = 2 * Maths.atan2(Maths.sqrt(aa), Maths.sqrt(1 - aa));
    return r * c;
  }

  double _deg2rad(double deg) => deg * (3.141592653589793 / 180.0);
}

// Minimal math helpers
class Maths {
  static double sin(double x) => math.sin(x);
  static double cos(double x) => math.cos(x);
  static double atan2(double y, double x) => math.atan2(y, x);
  static double sqrt(num x) => math.sqrt(x);
}
