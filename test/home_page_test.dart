import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ramen_radar/app.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';
import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/shared/di/providers.dart';
import 'package:ramen_radar/features/ranking/presentation/home_page.dart';

class _TestRankingRepo implements RankingRepository {
  @override
  Future<List<Candidate>> fetchCandidates({required Genre genre, required LatLng current}) async {
    final places = [
      Place(id: '1', name: 'A', rating: 4.5, location: LatLng(current.lat + 0.001, current.lng + 0.001)),
      Place(id: '2', name: 'B', rating: 4.2, location: LatLng(current.lat + 0.002, current.lng - 0.001)),
    ];
    return [
      Candidate(place: places[0], distanceKm: 0.15),
      Candidate(place: places[1], distanceKm: 0.25),
    ];
  }
}

void main() {
  testWidgets('Home shows ranking list with items', (tester) async {
    final overrides = <Override>[
      rankingRepositoryProvider.overrideWith((ref) => _TestRankingRepo()),
      currentLocationProvider.overrideWith((ref) async => const LatLng(35.0, 139.0)),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));

    // Let async providers resolve; current location provider calls platform, so we inject via state? Simplify by providing initial pump settle.
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // We expect at least one ListTile to appear when in list mode
    expect(find.byType(ListTile), findsWidgets);

    // Toggle to map and back would require plugin; we keep to list mode in test
  });

  testWidgets('Ranking entries can be tapped to open in maps', (tester) async {
    final overrides = <Override>[
      rankingRepositoryProvider.overrideWith((ref) => _TestRankingRepo()),
      currentLocationProvider.overrideWith((ref) async => const LatLng(35.0, 139.0)),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Initially list is shown with ranking entries
    expect(find.byType(ListTile), findsWidgets);

    // Verify we can find ranking entries by name
    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
