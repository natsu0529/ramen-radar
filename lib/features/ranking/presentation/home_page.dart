import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models.dart';
import '../../../scoring.dart';
import '../../../shared/di/providers.dart';

final genreProvider = StateProvider<Genre>((ref) => Genre.all);

final currentLocationProvider = Provider<LatLng>((ref) {
  // Placeholder current location (Tokyo Station)
  return const LatLng(35.681236, 139.767125);
});

final rankingProvider = FutureProvider<List<RankingEntry>>((ref) async {
  final repo = ref.watch(rankingRepositoryProvider);
  final genre = ref.watch(genreProvider);
  final current = ref.watch(currentLocationProvider);
  final candidates = await repo.fetchCandidates(genre: genre, current: current);
  return computeRanking(candidates);
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genre = ref.watch(genreProvider);
    final ranking = ref.watch(rankingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ramen Radar'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _GenreChips(genre: genre, onChanged: (g) => ref.read(genreProvider.notifier).state = g),
          const Divider(height: 1),
          Expanded(
            child: ranking.when(
              data: (list) => _RankingList(entries: list),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('エラー: $e'),
                ),
              ),
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
          label: const Text('ALL'),
          selected: genre == Genre.all,
          onSelected: (_) => onChanged(Genre.all),
        ),
        ChoiceChip(
          label: const Text('家系'),
          selected: genre == Genre.iekei,
          onSelected: (_) => onChanged(Genre.iekei),
        ),
        ChoiceChip(
          label: const Text('二郎系'),
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
              const Text('スポット評価:'),
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
                subtitle: Text('評価 ${e.place.rating.toStringAsFixed(1)}・距離 ${_fmtDistance(e.roundedDistanceKm)} km'),
                trailing: Text(e.score.toStringAsFixed(2)),
              );
            },
          ),
        ),
      ],
    );
  }

  String _fmtDistance(double km) {
    if (km < 1.0) {
      return km.toStringAsFixed(2);
    }
    // Keep as is, already rounded by logic; format to 2 decimals for display consistency
    return km.toStringAsFixed(2);
  }
}

