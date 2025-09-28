import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ramen_radar/app.dart';
import 'package:ramen_radar/features/ranking/presentation/home_page.dart';
import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/shared/di/providers.dart';
import 'package:ramen_radar/shared/utils/location_service.dart';

void main() {
  testWidgets('Shows location permission denied error', (tester) async {
    final overrides = <Override>[
      currentLocationProvider.overrideWith((ref) => Future<LatLng>.error(
            LocationException('permission_denied', 'denied'),
          )),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Expect a Retry button to be present (localized in en by default as 'Retry')
    expect(find.textContaining('Retry'), findsOneWidget);
  });

  testWidgets('Shows location permission denied forever error', (tester) async {
    final overrides = <Override>[
      currentLocationProvider.overrideWith((ref) => Future<LatLng>.error(
            LocationException('permission_denied_forever', 'forever'),
          )),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.textContaining('Open Settings'), findsOneWidget);
  });

  testWidgets('Shows ranking fetch error message', (tester) async {
    final overrides = <Override>[
      currentLocationProvider.overrideWith((ref) async => const LatLng(35.0, 139.0)),
      rankingRepositoryProvider.overrideWith((ref) => _ErrorRepo()),
    ];

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: const RamenRadarApp(),
    ));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.textContaining('Failed to fetch ranking'), findsOneWidget);
  });
}

class _ErrorRepo implements RankingRepository {
  @override
  Future<List<Candidate>> fetchCandidates({required Genre genre, required LatLng current}) {
    return Future.error(Exception('failed'));
  }
}

