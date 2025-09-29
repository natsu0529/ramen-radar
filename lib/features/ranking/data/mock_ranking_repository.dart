import 'dart:math' as math;
import 'dart:developer' as developer;

import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';

class MockRankingRepository implements RankingRepository {
  @override
  Future<List<Candidate>> fetchCandidates({
    required Genre genre,
    required LatLng current,
  }) async {
    developer.log('=== DEBUG: MockRankingRepository.fetchCandidates START ===');
    developer.log('DEBUG: Genre: $genre');
    developer.log('DEBUG: Current location: $current');
    // Static mock data for initial UI wiring
    // Distances are raw; will be rounded by scoring logic
    final base = <Place>[
      Place(id: '1', name: '麺匠 一輝', rating: 4.5, location: LatLng(current.lat + 0.002, current.lng + 0.002), tags: const []),
      Place(id: '2', name: '家系 武蔵屋', rating: 4.2, location: LatLng(current.lat + 0.004, current.lng - 0.001), tags: const [RamenTag.iekei]),
      Place(id: '3', name: '二郎系 雷神', rating: 4.0, location: LatLng(current.lat - 0.006, current.lng + 0.003), tags: const [RamenTag.jiro]),
    ];

    final filtered = base.where((p) {
      switch (genre) {
        case Genre.all:
          return true;
        case Genre.iekei:
          return p.tags.contains(RamenTag.iekei);
        case Genre.jiro:
          return p.tags.contains(RamenTag.jiro);
      }
    }).toList();

    // Simple Haversine distance approximation (km)
    double haversineKm(LatLng a, LatLng b) {
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

    return filtered
        .map((p) => Candidate(place: p, distanceKm: haversineKm(current, p.location)))
        .toList();
  }
}

double _deg2rad(double deg) => deg * (3.141592653589793 / 180.0);

// Minimal math helpers to avoid importing dart:math alias conflicts above
class Maths {
  static double sin(double x) => math.sin(x);
  static double cos(double x) => math.cos(x);
  static double atan2(double y, double x) => math.atan2(y, x);
  static double sqrt(num x) => math.sqrt(x);
}
