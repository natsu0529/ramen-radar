import 'dart:math' as math;

import 'package:ramen_radar/models.dart';

/// Round distance according to the spec:
/// - If < 1km, keep as-is (no rounding)
/// - If >= 1km, round to two significant figures
double roundDistanceKm(double km) {
  if (km.isNaN || km.isInfinite) return km;
  if (km < 1.0) return km;
  // two significant figures
  final absVal = km.abs();
  final log10 = math.log(absVal) / math.ln10;
  final digits = 2 - log10.floor() - 1; // n - 1 - floor(log10(x)) with n=2
  final factor = math.pow(10.0, digits.toDouble());
  final rounded = (km * factor).roundToDouble() / factor;
  return rounded;
}

/// Compute total score on a 10-point scale by formula:
///   score = (rating * 2) - roundedDistanceKm
/// rating: 0..5
double computeScore({required double rating, required double roundedDistanceKm}) {
  return (rating * 2.0) - roundedDistanceKm;
}

/// Compute the spot letter grade from the average score of top 10.
/// S: >= 8.50, A: 7.50..8.49, B: 6.50..7.49, C: 5.50..6.49, D: <= 5.49
String spotGradeFromAverage(double avg) {
  if (avg >= 8.50) return 'S';
  if (avg >= 7.50) return 'A';
  if (avg >= 6.50) return 'B';
  if (avg >= 5.50) return 'C';
  return 'D';
}

/// Compute ranking entries from nearby candidates.
/// Applies distance rounding and scoring, then sorts by score desc, distance asc.
List<RankingEntry> computeRanking(List<Candidate> candidates) {
  final entries = candidates.map((c) {
    final rd = roundDistanceKm(c.distanceKm);
    final score = computeScore(rating: c.place.rating, roundedDistanceKm: rd);
    return RankingEntry(place: c.place, score: score, roundedDistanceKm: rd);
  }).toList();

  entries.sort((a, b) {
    final s = b.score.compareTo(a.score); // desc
    if (s != 0) return s;
    return a.roundedDistanceKm.compareTo(b.roundedDistanceKm); // asc tie-breaker
  });

  return entries.take(10).toList();
}

/// Compute the spot grade from ranking entries (top-10 average of scores).
String computeSpotGrade(List<RankingEntry> entries) {
  if (entries.isEmpty) return 'D';
  final top = entries.take(10).toList();
  final avg = top.map((e) => e.score).fold<double>(0, (a, b) => a + b) / top.length;
  return spotGradeFromAverage(avg);
}
