import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models.dart';
import '../../../scoring.dart';
import '../../../shared/di/providers.dart';
import '../../../shared/theme/score_colors.dart';
import '../../../shared/utils/location_service.dart';
import '../../../shared/utils/network_status.dart';
import 'map_widget.dart';
import 'place_detail_sheet.dart';
import 'last_ranking_provider.dart';

final genreProvider = StateProvider<Genre>((ref) => Genre.all);
enum ViewMode { list, map }
final viewModeProvider = StateProvider<ViewMode>((ref) => ViewMode.list);

final currentLocationProvider = FutureProvider<LatLng>((ref) async {
  final svc = ref.watch(locationServiceProvider);
  return svc.getCurrentLatLng();
});

final rankingProvider = FutureProvider<List<RankingEntry>>((ref) async {
  final repo = ref.watch(rankingRepositoryProvider);
  final genre = ref.watch(genreProvider);
  final current = await ref.watch(currentLocationProvider.future);
  final candidates = await repo.fetchCandidates(genre: genre, current: current);
  return computeRanking(candidates);
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genre = ref.watch(genreProvider);
    final viewMode = ref.watch(viewModeProvider);
    final loc = ref.watch(currentLocationProvider);
    final ranking = ref.watch(rankingProvider);
    final connectivity = ref.watch(connectivityProvider).value;
    final offline = connectivity != null && isOffline(connectivity);
    final lastRanking = ref.watch(lastRankingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
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
          _ViewToggle(
            mode: viewMode,
            onChanged: (m) => ref.read(viewModeProvider.notifier).state = m,
          ),
          if (offline)
            Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('${AppLocalizations.of(context)!.offline} ・ ${AppLocalizations.of(context)!.showingLastResults}'),
            ),
          Expanded(
            child: loc.when(
              data: (pos) => ranking.when(
                data: (list) {
                  // cache last successful result
                  ref.read(lastRankingProvider.notifier).state = list;
                  return viewMode == ViewMode.list
                    ? _RankingList(entries: list, onSelect: (e) => showPlaceDetailSheet(context, e))
                    : ref.watch(mapWidgetBuilderProvider)(
                        current: pos,
                        entries: list,
                        onSelect: (e) => showPlaceDetailSheet(context, e),
                      );
                },
                loading: () => viewMode == ViewMode.list
                    ? const _ListSkeleton()
                    : const Center(child: CircularProgressIndicator()),
                error: (e, st) => offline && lastRanking != null
                    ? (viewMode == ViewMode.list
                        ? _RankingList(entries: lastRanking, onSelect: (e) => showPlaceDetailSheet(context, e))
                        : ref.watch(mapWidgetBuilderProvider)(
                            current: pos,
                            entries: lastRanking,
                            onSelect: (e) => showPlaceDetailSheet(context, e),
                          ))
                    : _ErrorView(
                        message: '${AppLocalizations.of(context)!.errorRankingFetch}\n$e',
                        onRetry: () => ref.invalidate(rankingProvider),
                      ),
              ),
              loading: () => viewMode == ViewMode.list
                  ? const _ListSkeleton()
                  : const Center(child: CircularProgressIndicator()),
              error: (e, st) => _LocationErrorView(error: e, onRetry: () {
                ref.invalidate(currentLocationProvider);
              }, onOpenSettings: () async {
                await ref.read(locationServiceProvider).openAppSettings();
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
          label: Text(AppLocalizations.of(context)!.genreAll),
          selected: genre == Genre.all,
          onSelected: (_) => onChanged(Genre.all),
        ),
        ChoiceChip(
          label: Text(AppLocalizations.of(context)!.genreIekei),
          selected: genre == Genre.iekei,
          onSelected: (_) => onChanged(Genre.iekei),
        ),
        ChoiceChip(
          label: Text(AppLocalizations.of(context)!.genreJiro),
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
              Text('${AppLocalizations.of(context)!.spotGradeLabel}:'),
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
                final t = AppLocalizations.of(context)!;
                final chipBg = scoreColor(color, e.score).withOpacity(0.15);
                final chipFg = scoreColor(color, e.score);
                return Semantics(
                  label: '${e.place.name}, ${t.rating(e.place.rating.toStringAsFixed(1))}, ${t.distanceKm(_fmtDistance(e.roundedDistanceKm))}',
                  button: true,
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: color.primaryContainer, child: Text('${index + 1}')),
                    title: Text(e.place.name),
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
                    trailing: Chip(
                      backgroundColor: chipBg,
                      label: Text(e.score.toStringAsFixed(2), style: TextStyle(color: chipFg, fontWeight: FontWeight.bold)),
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

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.mode, required this.onChanged});
  final ViewMode mode;
  final ValueChanged<ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SegmentedButton<ViewMode>(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: [
          ButtonSegment<ViewMode>(value: ViewMode.list, label: Text(t.list), icon: const Icon(Icons.list)),
          ButtonSegment<ViewMode>(value: ViewMode.map, label: Text(t.map), icon: const Icon(Icons.map_outlined)),
        ],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton({this.items = 6});
  final int items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items,
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
            ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
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
    String message = AppLocalizations.of(context)!.errorLocationGeneric;
    if (error is LocationException) {
      final e = error as LocationException;
      switch (e.code) {
        case 'service_disabled':
          message = AppLocalizations.of(context)!.errorLocationServiceDisabled;
          break;
        case 'permission_denied':
          message = AppLocalizations.of(context)!.errorPermissionDenied;
          break;
        case 'permission_denied_forever':
          message = AppLocalizations.of(context)!.errorPermissionDeniedForever;
          break;
        case 'timeout':
          message = AppLocalizations.of(context)!.errorTimeout;
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
                ElevatedButton(onPressed: onRetry, child: Text(AppLocalizations.of(context)!.retry)),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: onOpenSettings, child: Text(AppLocalizations.of(context)!.openSettings)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
