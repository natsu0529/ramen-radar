import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ramen_radar/app.dart';
import 'package:ramen_radar/features/ranking/domain/ranking_repository.dart';
import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/shared/di/providers.dart';
import 'package:ramen_radar/features/ranking/presentation/home_page.dart';
import 'package:ramen_radar/features/ranking/presentation/map_widget.dart';

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

  testWidgets('Toggle to map uses injected map builder', (tester) async {
    final overrides = <Override>[
      rankingRepositoryProvider.overrideWith((ref) => _TestRankingRepo()),
      currentLocationProvider.overrideWith((ref) async => const LatLng(35.0, 139.0)),
      mapWidgetBuilderProvider.overrideWith((ref) => ({required current, required entries}) => Container(key: const Key('test-map'))),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Initially list is shown
    expect(find.byType(ListTile), findsWidgets);

    // Tap the 'Map' toggle button
    // Use text from localization likely 'List'/'Map' in en locale
    await tester.tap(find.text('Map'));
    await tester.pumpAndSettle();

    // Our injected map placeholder should be visible
    expect(find.byKey(const Key('test-map')), findsOneWidget);
  });
}
