import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models.dart';
import '../../../scoring.dart';
import '../../../shared/di/providers.dart';
import '../../../shared/utils/location_service.dart';
import 'map_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
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
          Expanded(
            child: loc.when(
              data: (pos) => ranking.when(
                data: (list) => viewMode == ViewMode.list
                    ? _RankingList(entries: list)
                    : ref.watch(mapWidgetBuilderProvider)(current: pos, entries: list),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => _ErrorView(
                  message: '${AppLocalizations.of(context)!.errorRankingFetch}\n$e',
                  onRetry: () {
                    ref.invalidate(rankingProvider);
                  },
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
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
  const _RankingList({required this.entries});
  final List<RankingEntry> entries;

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
          child: ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final e = entries[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text(e.place.name),
                subtitle: Text(
                  '${AppLocalizations.of(context)!.rating(e.place.rating.toStringAsFixed(1))}・${AppLocalizations.of(context)!.distanceKm(_fmtDistance(e.roundedDistanceKm))}',
                ),
                trailing: Text(e.score.toStringAsFixed(2)),
              );
            },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ToggleButtons(
        isSelected: [mode == ViewMode.list, mode == ViewMode.map],
        onPressed: (index) => onChanged(index == 0 ? ViewMode.list : ViewMode.map),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AppLocalizations.of(context)!.list)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(AppLocalizations.of(context)!.map)),
        ],
      ),
    );
  }
}

// Map rendering moved to map_widget.dart and is overridable via Provider for testing.

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
