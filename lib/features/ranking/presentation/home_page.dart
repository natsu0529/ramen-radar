import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ramen_radar/l10n/app_localizations.dart';

import 'package:ramen_radar/models.dart';
import 'package:ramen_radar/scoring.dart';
import 'package:ramen_radar/shared/di/providers.dart';
import 'package:ramen_radar/shared/theme/score_colors.dart';
import 'package:ramen_radar/shared/utils/location_service.dart';
import 'package:ramen_radar/shared/utils/network_status.dart';
import 'package:ramen_radar/features/ranking/presentation/last_ranking_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final genreProvider = StateProvider<Genre>((ref) => Genre.all);

enum _LangChoice { en, ja }

final currentLocationProvider = FutureProvider<LatLng>((ref) async {
  final svc = ref.watch(locationServiceProvider);
  return svc.getCurrentLatLng();
});

final rankingProvider = FutureProvider<List<RankingEntry>>((ref) async {
  try {
    print('=== DEBUG: rankingProvider START ===');
    final repo = ref.watch(rankingRepositoryProvider);
    print('DEBUG: rankingRepositoryProvider type: ${repo.runtimeType}');
    final genre = ref.watch(genreProvider);
    print('DEBUG: genre: $genre');
    final current = await ref.watch(currentLocationProvider.future);
    print('DEBUG: current location from provider: $current');
    print('DEBUG: About to call repo.fetchCandidates...');
    final candidates = await repo.fetchCandidates(genre: genre, current: current);
    print('DEBUG: candidates received: ${candidates.length} items');
    final ranking = computeRanking(candidates);
    print('DEBUG: ranking computed: ${ranking.length} items');
    return ranking;
  } catch (e, stackTrace) {
    print('ERROR in rankingProvider: $e');
    print('ERROR stackTrace: $stackTrace');
    rethrow;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genre = ref.watch(genreProvider);
    final loc = ref.watch(currentLocationProvider);
    final ranking = ref.watch(rankingProvider);
    // Cache the last successful ranking result via a listener to avoid modifying providers during build.
    ref.listen<AsyncValue<List<RankingEntry>>>(rankingProvider, (prev, next) {
      next.whenData((list) {
        ref.read(lastRankingProvider.notifier).state = list;
      });
    });
    final connectivity = ref.watch(connectivityProvider).value;
    final offline = connectivity != null && isOffline(connectivity);
    final lastRanking = ref.watch(lastRankingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).appTitle),
        actions: [
          // Language switcher
          Consumer(builder: (context, ref, _) {
            final current = ref.watch(localeProvider);
            return PopupMenuButton<_LangChoice>(
              tooltip: 'Language',
              icon: const Icon(Icons.language),
              onSelected: (choice) {
                switch (choice) {
                  case _LangChoice.en:
                    ref.read(localeProvider.notifier).state = const Locale('en');
                    break;
                  case _LangChoice.ja:
                    ref.read(localeProvider.notifier).state = const Locale('ja');
                    break;
                }
              },
              itemBuilder: (context) => [
                CheckedPopupMenuItem(
                  value: _LangChoice.en,
                  checked: current?.languageCode == 'en',
                  child: const Text('EN'),
                ),
                CheckedPopupMenuItem(
                  value: _LangChoice.ja,
                  checked: current?.languageCode == 'ja',
                  child: const Text('日本語'),
                ),
              ],
            );
          }),
          IconButton(
            tooltip: MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
            onPressed: () => ref.invalidate(rankingProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _GenreChips(genre: genre, onChanged: (g) => ref.read(genreProvider.notifier).state = g),
          const Divider(height: 1),
          if (offline)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('${AppLocalizations.of(context).offline} ・ ${AppLocalizations.of(context).showingLastResults}'),
            ),
          Expanded(
            child: loc.when(
              data: (pos) => ranking.when(
                data: (list) {
                  return _RankingList(
                    entries: list,
                    onSelect: (e) => _openInMaps(e.place.location, placeId: e.place.id),
                  );
                },
                loading: () => const _ListSkeleton(),
                error: (e, st) => offline && lastRanking != null
                    ? _RankingList(entries: lastRanking, onSelect: (e) => _openInMaps(e.place.location, placeId: e.place.id))
                    : _ErrorView(
                        message: '${AppLocalizations.of(context).errorRankingFetch}\n$e',
                        onRetry: () => ref.invalidate(rankingProvider),
                      ),
              ),
              loading: () => const _ListSkeleton(),
              error: (e, st) => _LocationErrorView(error: e, onRetry: () {
                ref.invalidate(currentLocationProvider);
              }, onOpenSettings: () async {
                final svc = ref.read(locationServiceProvider);
                if (e is LocationException && e.code == 'service_disabled') {
                  await svc.openLocationSettings();
                } else {
                  await svc.openAppSettings();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreChips extends StatelessWidget {
  const _GenreChips({required this.genre, required this.onChanged});
  final Genre genre;
  final ValueChanged<Genre> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: Text(AppLocalizations.of(context).genreAll),
          selected: genre == Genre.all,
          onSelected: (_) => onChanged(Genre.all),
        ),
        ChoiceChip(
          label: Text(AppLocalizations.of(context).genreIekei),
          selected: genre == Genre.iekei,
          onSelected: (_) => onChanged(Genre.iekei),
        ),
        ChoiceChip(
          label: Text(AppLocalizations.of(context).genreJiro),
          selected: genre == Genre.jiro,
          onSelected: (_) => onChanged(Genre.jiro),
        ),
      ],
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.entries, required this.onSelect});
  final List<RankingEntry> entries;
  final void Function(RankingEntry) onSelect;

  @override
  Widget build(BuildContext context) {
    final avgGrade = computeSpotGrade(entries);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text('${AppLocalizations.of(context).spotGradeLabel}:'),
              const SizedBox(width: 8),
              Chip(label: Text(avgGrade)),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {},
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final e = entries[index];
                final color = Theme.of(context).colorScheme;
                final t = AppLocalizations.of(context);
                final chipBg = scoreColor(color, e.score).withValues(alpha: 0.15);
                final chipFg = scoreColor(color, e.score);
                return Semantics(
                  label: '${e.place.name}, ${t.rating(e.place.rating.toStringAsFixed(1))}, ${t.distanceKm(_fmtDistance(e.roundedDistanceKm))}',
                  button: true,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('#${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    title: InkWell(
                      onTap: () => onSelect(e),
                      child: Text(
                        e.place.name,
                        style: const TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${t.rating(e.place.rating.toStringAsFixed(1))}・${t.distanceKm(_fmtDistance(e.roundedDistanceKm))}'),
                        if (e.place.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              spacing: 6,
                              children: e.place.tags.map((tag) => Chip(label: Text(_tagLabel(tag)))).toList(),
                            ),
                          ),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppLocalizations.of(context).score(e.score.toStringAsFixed(2)),
                        style: TextStyle(color: chipFg, fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () => onSelect(e),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
}

}

// Map rendering is provided via Provider to allow test overrides.

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: double.infinity, color: Colors.black12),
                    const SizedBox(height: 8),
                    Container(height: 12, width: MediaQuery.of(context).size.width * 0.5, color: Colors.black12),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(height: 16, width: 40, color: Colors.black12),
            ],
          ),
        );
      },
    );
  }
}

// Map rendering moved to map_widget.dart and is overridable via Provider for testing.

String _tagLabel(RamenTag t) {
  switch (t) {
    case RamenTag.iekei:
      return '家系';
    case RamenTag.jiro:
      return '二郎系';
    case RamenTag.miso:
      return '味噌';
    case RamenTag.tonkotsu:
      return '豚骨';
  }
}

String _fmtDistance(double km) => km.toStringAsFixed(1);

Future<void> _openInMaps(LatLng loc, {String? placeId}) async {
  const base = 'https://www.google.com/maps/search/?api=1';
  final query = 'query=${Uri.encodeComponent('${loc.lat},${loc.lng}')}';
  final pid = (placeId != null && placeId.isNotEmpty) ? '&query_place_id=${Uri.encodeComponent(placeId)}' : '';
  final uri = Uri.parse('$base&$query$pid');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// View toggle removed

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
          ],
        ),
      ),
    );
  }
}

class _LocationErrorView extends StatelessWidget {
  const _LocationErrorView({required this.error, required this.onRetry, required this.onOpenSettings});
  final Object error;
  final VoidCallback onRetry;
  final Future<void> Function() onOpenSettings;

  @override
  Widget build(BuildContext context) {
    String message = AppLocalizations.of(context).errorLocationGeneric;
    if (error is LocationException) {
      final e = error as LocationException;
      switch (e.code) {
        case 'service_disabled':
          message = AppLocalizations.of(context).errorLocationServiceDisabled;
          break;
        case 'permission_denied':
          message = AppLocalizations.of(context).errorPermissionDenied;
          break;
        case 'permission_denied_forever':
          message = AppLocalizations.of(context).errorPermissionDeniedForever;
          break;
        case 'timeout':
          message = AppLocalizations.of(context).errorTimeout;
          break;
        default:
          message = e.message;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: onOpenSettings, child: Text(AppLocalizations.of(context).openSettings)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
