import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models.dart';
import '../../../scoring.dart';
import '../../../shared/di/providers.dart';
import '../../../shared/utils/location_service.dart';

final genreProvider = StateProvider<Genre>((ref) => Genre.all);

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
    final loc = ref.watch(currentLocationProvider);
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
            child: loc.when(
              data: (_) => ranking.when(
                data: (list) => _RankingList(entries: list),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => _ErrorView(
                  message: 'ランキングの取得に失敗しました\n$e',
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
            ElevatedButton(onPressed: onRetry, child: const Text('再試行')),
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
    String message = '現在地の取得に失敗しました';
    if (error is LocationException) {
      final e = error as LocationException;
      switch (e.code) {
        case 'service_disabled':
          message = '位置情報サービスが無効です。端末の設定を確認してください。';
          break;
        case 'permission_denied':
          message = '位置情報の権限が拒否されました。許可してください。';
          break;
        case 'permission_denied_forever':
          message = '位置情報の権限が恒久的に拒否されています。設定から許可してください。';
          break;
        case 'timeout':
          message = '現在地の取得がタイムアウトしました。再試行してください。';
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
                ElevatedButton(onPressed: onRetry, child: const Text('再試行')),
                const SizedBox(width: 12),
                OutlinedButton(onPressed: onOpenSettings, child: const Text('設定を開く')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  String _fmtDistance(double km) {
    if (km < 1.0) {
      return km.toStringAsFixed(2);
    }
    // Keep as is, already rounded by logic; format to 2 decimals for display consistency
    return km.toStringAsFixed(2);
  }
}
