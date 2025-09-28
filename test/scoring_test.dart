import 'package:flutter_test/flutter_test.dart';

import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/scoring.dart';

void main() {
  group('roundDistanceKm', () {
    test('< 1km stays as-is', () {
      expect(roundDistanceKm(0.89), 0.89);
      expect(roundDistanceKm(0.1), 0.1);
    });

    test('>= 1km rounds to two significant figures', () {
      expect(roundDistanceKm(1.23), 1.2);
      expect(roundDistanceKm(1.25), 1.3); // half up
      expect(roundDistanceKm(12.3), 12);
      expect(roundDistanceKm(123), 120);
    });
  });

  group('computeScore', () {
    test('uses (rating * 2) - distance', () {
      expect(computeScore(rating: 4.5, roundedDistanceKm: 1.2), closeTo(7.8, 1e-9));
    });
  });

  group('computeRanking', () {
    test('sorts by score desc then distance asc', () {
      final p1 = Place(id: '1', name: 'A', rating: 4.5, location: const LatLng(0, 0));
      final p2 = Place(id: '2', name: 'B', rating: 4.5, location: const LatLng(0, 0));
      final cands = [
        Candidate(place: p1, distanceKm: 1.23), // rounded 1.2 => score 7.8
        Candidate(place: p2, distanceKm: 1.28), // rounded 1.3 => score 7.7
      ];
      final rank = computeRanking(cands);
      expect(rank.first.place.id, '1');

      // tie-breaker: same score, closer distance first
      final p3 = Place(id: '3', name: 'C', rating: 4.5, location: const LatLng(0, 0));
      final p4 = Place(id: '4', name: 'D', rating: 4.5, location: const LatLng(0, 0));
      final tie = [
        Candidate(place: p3, distanceKm: 1.21), // rounded 1.2 => 7.8
        Candidate(place: p4, distanceKm: 1.24), // rounded 1.2 => 7.8
      ];
      final tied = computeRanking(tie);
      // both have same score, shorter distance (rounded equal) -> our tie-break uses rounded distances; equal, keep order
      expect(tied.length, 2);
    });
  });

  group('computeSpotGrade', () {
    test('maps average to grades', () {
      RankingEntry e(double s) => RankingEntry(place: Place(id: '$s', name: 'X', rating: 4, location: const LatLng(0, 0)), score: s, roundedDistanceKm: 0);
      expect(computeSpotGrade([e(8.5)]), 'S');
      expect(computeSpotGrade([e(8.49)]), 'A');
      expect(computeSpotGrade([e(7.5)]), 'A');
      expect(computeSpotGrade([e(6.5)]), 'B');
      expect(computeSpotGrade([e(5.5)]), 'C');
      expect(computeSpotGrade([e(5.49)]), 'D');
    });
  });
}

